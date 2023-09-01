//
//  PurchaseController.swift
//  CashMore
//
//  Created by Tim on 2023/6/12.
//

import Contacts
import AdSupport
import CoreTelephony
import FacebookCore

class PurchaseController : BaseScrollController {
    
    var isRecommend : Bool = false
    
    var productDetail : ProductDetailModel! {
        didSet {
            productImgView.kf.setImage(with: URL(string: productDetail.logo))
            productNameLabel.text = productDetail.loanName
            amountView.subtitle = "₹ " + productDetail.loanAmountStr
            termsView.subtitle  = productDetail.loanDate + " Days"
            receivedView.subtitle = "₹ " + productDetail.receiveAmountStr
            verifyFeeView.subtitle = "₹ " + productDetail.verificationFeeStr
            gstView.subtitle = "₹ " + productDetail.gstFeeStr
            interestView.subtitle = "₹ " + productDetail.interestAmountStr
            overdueView.subtitle = productDetail.overdueChargeStr + "/day"
            paymentAmountView.subtitle = "₹ " + productDetail.repayAmountStr
        }
    }
    
    private lazy var productImgView   : UIImageView = UIImageView()
    private lazy var productNameLabel = {
        let lb = UILabel()
        lb.textColor = Constants.themeTitleColor
        lb.font = Constants.pingFangSCRegularFont(20)
        return lb
    }()
    private lazy var amountView    = OrderDetailItemView(title: "Amount")
    private lazy var termsView     = OrderDetailItemView(title: "Terms")
    private lazy var receivedView  = OrderDetailItemView(title: "Received Amount")
    private lazy var verifyFeeView = OrderDetailItemView(title: "Verification Fee")
    private lazy var gstView       = OrderDetailItemView(title: "GST")
    private lazy var interestView  = OrderDetailItemView(title: "Interest")
    private lazy var overdueView   = OrderDetailItemView(title: "Overdue Charge")
    private lazy var paymentAmountView = OrderDetailItemView(title: "Repayment Amount")
    private lazy var aprView       = OrderDetailItemView(title: "APR", subTitle: "18.25%")
    private lazy var purchaseBtn   = Constants.themeBtn(with: "Loan now")
    
    private var userInfo : UserInfoModel?
    
    private lazy var contactStore: CNContactStore = CNContactStore()
    private var phoneList : [[String : String]]?
    private var latitude  : String?
    private var longitude : String?
}


// MARK: - Config UI
extension PurchaseController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isRecommend {
            popGestureClose()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isRecommend {
            popGestureOpen()
        }
    }
    
    override func configUI() {
        super.configUI()
        title = "Detail"
        view.backgroundColor = Constants.pureWhite
        
        if Constants.userPhoneNumber != Constants.testAccountPhoneNumber {
            checkContactStoreAuth { list in
                self.phoneList = list
            }

            getLocationInfo { latitude, longitude in
                self.latitude = latitude
                self.longitude = longitude
            }
        }
        
        let headerView = UIImageView(image: R.image.purchase_icon())
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        let productInfoView = UIView()
        contentView.addSubview(productInfoView)
        productInfoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(20)
        }
        
        productInfoView.addSubview(productImgView)
        productImgView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        productImgView.tm.setCorner(25)
        
        productInfoView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(productImgView.snp.right).offset(14)
        }
        
        contentView.addSubview(amountView)
        contentView.addSubview(termsView)
        contentView.addSubview(receivedView)
        contentView.addSubview(verifyFeeView)
        contentView.addSubview(gstView)
        contentView.addSubview(interestView)
        contentView.addSubview(overdueView)
        contentView.addSubview(paymentAmountView)
        if Constants.userPhoneNumber == Constants.testAccountPhoneNumber {
            contentView.addSubview(aprView)
        }
        
        
        amountView.snp.makeConstraints { make in
            make.top.equalTo(productInfoView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        termsView.snp.makeConstraints { make in
            make.top.equalTo(amountView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        receivedView.snp.makeConstraints { make in
            make.top.equalTo(termsView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        verifyFeeView.snp.makeConstraints { make in
            make.top.equalTo(receivedView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        gstView.snp.makeConstraints { make in
            make.top.equalTo(verifyFeeView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        interestView.snp.makeConstraints { make in
            make.top.equalTo(gstView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        overdueView.snp.makeConstraints { make in
            make.top.equalTo(interestView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        paymentAmountView.snp.makeConstraints { make in
            make.top.equalTo(overdueView.snp.bottom)
            make.left.right.equalTo(amountView)
        }
        
        if Constants.userPhoneNumber == Constants.testAccountPhoneNumber {
            aprView.snp.makeConstraints { make in
                make.top.equalTo(paymentAmountView.snp.bottom)
                make.left.right.equalTo(amountView)
            }
        }
        
        contentView.addSubview(purchaseBtn)
        purchaseBtn.snp.makeConstraints { make in
            make.top.equalTo(paymentAmountView.snp.bottom).offset(40)
            make.size.equalTo(CGSize(width: 265, height: 50))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Constants.bottomSafeArea).priority(.high)
        }
        purchaseBtn.addTarget(self, action: #selector(loanAction), for: .touchUpInside)
    }
    
    override func goBack() {
        if isRecommend {
            navigationController?.dismiss(animated: true)
        } else {
            super.goBack()
            ADJustTrackTool.point(name: "yr5726")
        }
    }
}

extension PurchaseController {
    @objc func loanAction() {
        ADJustTrackTool.point(name: "db9hwk")
        APIService.standered.fetchModel(api: API.Me.userInfo, type: UserInfoModel.self) { model in
            self.userInfo = model
            if model.userLiveness {
                self.confirmLoanAction()
            } else {
                TipsSheet.show(message: "Please upload a selfie photo before continuing.", confirmAction:  {
                    let inVivoDetectionVC = InVivoDetectionController()
                    inVivoDetectionVC.selectedPhoto = self.selectedPhotoAction(_:)
                    self.navigationController?.pushViewController(inVivoDetectionVC, animated: true)
                })
            }
        }
        
    }
    
    private func selectedPhotoAction(_ image: UIImage?) {
        APIService.standered.faceVerifyService(image) {
            self.confirmLoanAction()
        } failuer: {
            TipsSheet.show(message: "Upload failed, please try again.", confirmAction:  {
                let inVivoDetectionVC = InVivoDetectionController()
                inVivoDetectionVC.selectedPhoto = self.selectedPhotoAction(_:)
                self.navigationController?.pushViewController(inVivoDetectionVC, animated: true)
            })
        }
    }
    
    private func confirmLoanAction() {
        
        var params : [String : Any] = [:]
        params["productId"] = productDetail.productId
        params["loanAmount"] = productDetail.loanAmountStr
        params["loanDate"] = productDetail.loanDate
        
        var data : [String : Any] = [:]
        
        var deviceAllInfo : [String : Any] = [:]
        deviceAllInfo["idfa"]  = UIDevice.tm.idfa.tm.isBlank ? nil : UIDevice.tm.idfa
        deviceAllInfo["udid"]  = UIDevice.tm.uuid
        deviceAllInfo["model"] = UIDevice.tm.modelName
        deviceAllInfo["batteryStatus"] = UIDevice.tm.batteryStatus
        deviceAllInfo["isPhone"]  = !Constants.isIpad
        deviceAllInfo["isTablet"] = Constants.isIpad
        deviceAllInfo["batteryLevel"] = UIDevice.tm.batteryLevel
        deviceAllInfo["ipAddress"] = UIDevice.tm.ipAdress
        deviceAllInfo["bootTime"]  = UIDevice.tm.bootTime
        deviceAllInfo["time"]      = UIDevice.tm.uptime
        deviceAllInfo["networkType"] = UIDevice.tm.networkType
        deviceAllInfo["is4G"]      = UIDevice.tm.cellularType == "NETWORK_4G"
        deviceAllInfo["is5G"]      = UIDevice.tm.cellularType == "NETWORK_5G"
        deviceAllInfo["wifiConnected"] = UIDevice.tm.networkType == "NETWORK_WIFI"
        deviceAllInfo["sdkVersionName"] = UIDevice.current.systemVersion
        
        let totalDistSize = UIDevice.tm.totalDiskSpaceInGB.replacingOccurrences(of: " ", with: "")
        deviceAllInfo["externalTotalSize"] = totalDistSize
        deviceAllInfo["internalTotalSize"] = totalDistSize
        
        let availableDiskSize = UIDevice.tm.freeDiskSpaceInGB.replacingOccurrences(of: " ", with: "")
        deviceAllInfo["internalAvailableSize"] = availableDiskSize
        deviceAllInfo["externalAvailableSize"] = availableDiskSize
        
        deviceAllInfo["availableMemory"] = UIDevice.tm.freeDiskSpaceInBytes
        
        let result = Double(UIDevice.tm.usedDiskSpaceInBytes) / Double(UIDevice.tm.totalDiskSpaceInBytes) * 100
        deviceAllInfo["percentValue"] = Int(result)
        
        deviceAllInfo["language"] = UIDevice.tm.language
        deviceAllInfo["brand"]    = "Apple"
        deviceAllInfo["mobileData"] = UIDevice.tm.networkType != "NETWORK_WIFI" && UIDevice.tm.networkType != "notReachable"
        deviceAllInfo["languageList"] = UserDefaults.standard.object(forKey: "AppleLanguages")
        deviceAllInfo["screenWidth"]  = Constants.screenWidth
        deviceAllInfo["screenHeight"] = Constants.screenHeight
        deviceAllInfo["brightness"] = String(format: "%.0f", UIScreen.main.brightness * 100)
        deviceAllInfo["appOpenTime"] = UIDevice.tm.openAppTimeStamp
        deviceAllInfo["timezone"] = TimeZone.current.identifier
        
        
        if Constants.userPhoneNumber != Constants.testAccountPhoneNumber {
            guard let latitude = latitude,
                  let longitude = longitude else {
                return HUD.flash(.label("Lack of location information, please exit this page and enter again"), delay: 2.0)
            }
            deviceAllInfo["latitude"] = latitude
            deviceAllInfo["longitude"] = longitude
            
            guard let phoneList = phoneList else {
                return HUD.flash(.label("Lack of contact book information, please exit this page and enter again"), delay: 2.0)
            }
            
            data["phoneList"] = phoneList
        }
        
        data["deviceAllInfo"] = deviceAllInfo
        
        guard let data = try? JSONSerialization.data(withJSONObject: data),
              let dataStr = String(data: data, encoding: .utf8) else {
            return
        }
        params["data"] = dataStr
        
        APIService.standered.fetchResponseList(api: API.Product.loan, parameters: params, loadingMessage: "Your application is being submitted, please do not exit or return.") { content in
            if let isFirstApply = content.cont?["isFirstApply"] as? Int, isFirstApply == 1 {
                // 首单埋点
                ADJustTrackTool.point(name: "m5rw1u")
                FacebookTrackTool.point(name: .addedToCart)
            }
            let purchaseSuccessVC = PurchaseSuccessController()
            purchaseSuccessVC.isRecommend = self.isRecommend
            purchaseSuccessVC.products = [ProductModel].deserialize(from: content.list)
            self.navigationController?.pushViewController(purchaseSuccessVC, animated: true)
        }
    }
    
    private func getLocationInfo(success:@escaping (_ latitude: String, _ longitude: String) -> Void) {
        if LocationManager.shared.hasLocationPermission() && LocationManager.shared.hasLocationService() {
            LocationManager.shared.requestLocation()
            LocationManager.shared.getLocationHandle = { isSuccess, latitude, longitude in
                success("\(latitude)", "\(longitude)")
            }
        } else if !LocationManager.shared.hasLocationPermission() {
            showAlert(with: "This feature requires you to authorize this app to open the location service\nHow to set it: open phone Settings -> Privacy -> Location service")
        } else if !LocationManager.shared.hasLocationService() {
            HUD.flash(.label("Please switch location service to on"), delay: 2.0)
        }
    }
}

// MARK: - Contact
extension PurchaseController {
    private func checkContactStoreAuth(completionHandle: @escaping ([[String : String]]) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
            case .notDetermined:
                requestContactStoreAuthorization(contactStore, success: completionHandle)
            case .authorized:
                readContactsFromContactStore(contactStore, success: completionHandle)
            case .denied, .restricted:
            showAlert(with: "This feature requires you to authorize this app to open the address book\nHow to set it: open phone Settings -> Privacy -> address Book")
            default: break
            }
    }
    
    private func requestContactStoreAuthorization(_ contactStore:CNContactStore, success: @escaping ([[String : String]]) -> Void) {
        contactStore.requestAccess(for: .contacts, completionHandler: {[weak self] (granted, error) in
            if granted {
                self?.readContactsFromContactStore(contactStore, success: success)
            }
        })
    }
    
    private func readContactsFromContactStore(_ contactStore:CNContactStore, success: @escaping (([[String : String]]) -> Void)) {
        guard CNContactStore.authorizationStatus(for: .contacts) == .authorized else {
            return
        }
        
        let keys = [CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey]
        
        let fetch = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        
        DispatchQueue.global().async {
            do {
                var contactList : [[String : String]] = []
                try contactStore.enumerateContacts(with: fetch, usingBlock: { contact, stop in
                    let name = "\(contact.familyName)\(contact.givenName)"
                    var phoneNum : String = ""
                    for labeledValue in contact.phoneNumbers {
                        phoneNum = (labeledValue.value as CNPhoneNumber).stringValue
                    }
                    
                    contactList.append(["number" : phoneNum, "contactDisplayName" : name])
                })
                success(contactList)
            } catch let error {
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: "Unknow Error", subtitle: error.localizedDescription), delay: 1.0)
                }
            }
        }
    }
    
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
}
