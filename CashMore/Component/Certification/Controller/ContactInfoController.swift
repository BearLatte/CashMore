//
//  ContactInfoController.swift
//  CashMore
//
//  Created by Tim on 2023/6/6.
//

import UIKit
import Contacts

class ContactInfoController : BaseScrollController {
    override func configUI() {
        super.configUI()
        title = "Contact info"
        setIndicator(current: 3, count: 4)
        
        contentView.addSubview(parentItem)
        contentView.addSubview(familyItem)
        contentView.addSubview(colleagueItem)
        contentView.addSubview(nextBtn)
        
        parentItem.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        familyItem.snp.makeConstraints { make in
            make.top.equalTo(parentItem.snp.bottom)
            make.left.right.equalTo(parentItem)
        }
        
        colleagueItem.snp.makeConstraints { make in
            make.top.equalTo(familyItem.snp.bottom)
            make.left.right.equalTo(parentItem)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.top.equalTo(colleagueItem.snp.bottom).offset(30)
            make.left.equalTo(55)
            make.right.equalTo(-55)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().priority(.high)
        }
        nextBtn.addTarget(self, action: #selector(nextBtnAction), for: .touchUpInside)
    }
    
    private enum ContactType {
        case parents, family, colleague
    }
    
    private var currentContactType : ContactType = .parents
    
    lazy var contactStore: CNContactStore = {
        let cn:CNContactStore = CNContactStore()
        return cn
    }()
    
    private lazy var parentItem = ContactInfoInputView(title: "Parents Contact"){ [weak self] in
        self?.currentContactType = .parents
        self?.checkContactStoreAuth()
    }
    
    private lazy var familyItem = ContactInfoInputView(title: "Family Contact") {[weak self] in
        self?.currentContactType = .family
        self?.checkContactStoreAuth()
    }
    
    private lazy var colleagueItem = ContactInfoInputView(title: "Colleague Contact") {[weak self] in
        self?.currentContactType = .colleague
        self?.checkContactStoreAuth()
    }
    
    private var nextBtn = Constants.themeBtn(with: "Next")
}


// MARK: - Private method
extension ContactInfoController {
    private func showAlert(with message: String?) {
        let appearance = EAAlertView.EAAppearance(
            kTitleHeight: 0,
            kButtonHeight:44,
            kTitleFont: Constants.pingFangSCSemiboldFont(18),
            showCloseButton: false,
            shouldAutoDismiss: false,
            buttonsLayout: .horizontal)
        let alert = EAAlertView(appearance: appearance)
        alert.circleBG.removeFromSuperview()
        alert.addButton(backgroundImage: UIImage.tm.createImage(Constants.themeColor), "Go To Setting") {
            let settingUrl = NSURL(string: UIApplication.openSettingsURLString)!
            if UIApplication.shared.canOpenURL(settingUrl as URL) {
                UIApplication.shared.open(settingUrl as URL, options: [:], completionHandler: { (istrue) in })
            }
            alert.hideView()
        }
        alert.addButton(backgroundImage: UIImage.tm.createImage(Constants.themeDisabledColor), "Cancel") {
            alert.hideView()
        }
        alert.show("", subTitle: message, animationStyle: .bottomToTop)
    }
    
    
    private func checkContactStoreAuth() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
            case .notDetermined:
                requestContactStoreAuthorization(contactStore)
            case .authorized:
                readContactsFromContactStore(contactStore)
            case .denied, .restricted:
            showAlert(with: "This feature requires you to authorize this app to open the address book\nHow to set it: open phone Settings -> Privacy -> address Book")
            Constants.debugLog("无权限")
            default: break
            }
    }
    
    private func requestContactStoreAuthorization(_ contactStore:CNContactStore) {
        contactStore.requestAccess(for: .contacts, completionHandler: {[weak self] (granted, error) in
            if granted {
                self?.readContactsFromContactStore(contactStore)
            }
        })
    }
    
    private func readContactsFromContactStore(_ contactStore:CNContactStore) {
        guard CNContactStore.authorizationStatus(for: .contacts) == .authorized else {
            return
        }
        
        let keys = [CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey]
        
        let fetch = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        
        DispatchQueue.global().async {
            do {
                var contactList : [ContactModel] = []
                try contactStore.enumerateContacts(with: fetch, usingBlock: { contact, stop in
                    let name = "\(contact.familyName)\(contact.givenName)"
                    var phoneNum : String = ""
                    for labeledValue in contact.phoneNumbers {
                        phoneNum = (labeledValue.value as CNPhoneNumber).stringValue
                    }
                    contactList.append(ContactModel(name: name, phone: phoneNum))
                })
                DispatchQueue.main.async {
                    self.showContactPicker(contactList)
                }
            } catch let error {
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: "Unknow Error", subtitle: error.localizedDescription), delay: 1.0)
                }
            }
        }

    }
    
    private func showContactPicker(_ list: [ContactModel]) {
        view.endEditing(true)
        var indicatorText = ""
        switch currentContactType {
        case .parents:
            indicatorText = "Please choose your Parents Contact"
        case .family:
            indicatorText = "Please choose your Family Contact"
        case .colleague:
            indicatorText = "Please choose your Colleague Contact"
        }
        
        ListSelectionView(title: "Contact Book", unselectedIndicatorText: indicatorText, contentList: list) { model in
            let contact = model as! ContactModel
            switch self.currentContactType {
            case .parents:
                self.parentItem.contact = contact
            case .family:
                self.familyItem.contact = contact
            case .colleague:
                self.colleagueItem.contact = contact
            }
        }
    }
    
    
    @objc func nextBtnAction() {
        guard let parentsContact = parentItem.contact, !parentsContact.name.tm.isBlank, !parentsContact.phoneNumber.tm.isBlank else {
            HUD.flash(.label("Please check the Parents Contact"), delay: 1.0)
            return
        }

        guard let familyContact = familyItem.contact, !familyContact.name.tm.isBlank, !familyContact.phoneNumber.tm.isBlank else {
            HUD.flash(.label("Please check the Family Contact"), delay: 1.0)
            return
        }

        guard let colleagueContact = colleagueItem.contact, !colleagueContact.name.tm.isBlank, !colleagueContact.phoneNumber.tm.isBlank else {
            HUD.flash(.label("Please check the Colleague Contact"), delay: 1.0)
            return
        }
        
        navigationController?.pushViewController(BankInfoController(), animated: true)
    }
       
}
