//
//  ProblemPhotosView.swift
//  CashMore
//
//  Created by Tim on 2023/6/16.
//

import UIKit
import Photos
import PhotosUI

class ProblemPhotosView: UIView {
    
    enum PhotoViewType {
        case upload, preview
    }
    
    // 图片url数组
    var imgUrls : [String] = [] {
        didSet {
            configImages()
        }
    }
    
    // 图片数组
    var images : [UIImage] = [] {
        didSet {
            configImages()
        }
    }
    
    convenience init(type: PhotoViewType = .upload, maxItem: Int = 9) {
        self.init(frame: .zero)
        self.photoViewType = type
        self.maxItem = maxItem
        configImages()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private lazy var addBtn = {
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(R.image.add_picture_icon(), for: .normal)
        btn.addTarget(self, action: #selector(addBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    private var photoViewType : PhotoViewType = .upload
    private var maxItem : Int = 9
}

extension ProblemPhotosView {
    private func configImages() {
        subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        if photoViewType == .upload {
            if images.count < maxItem {
                addSubview(addBtn)
            }
            
            for i in 0 ..< images.count {
                let itemView = PhotoItemView(showsDeleteBtn: true, tag: i + 999) { tag in
                    self.images.remove(at: tag % 999)
                    self.imgUrls.remove(at: tag % 999)
                    self.configImages()
                }
                itemView.image = images[i]
                addSubview(itemView)
            }
            layoutIfNeeded()
        } else {
            imgUrls.forEach { url in
                let itemView = PhotoItemView(showsDeleteBtn: false)
                itemView.imageUrl = url
                addSubview(itemView)
            }
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.width == 0 {
            return
        }
        // 列数
        let maxCol = 3
        let margin : CGFloat = 9.0
        let itemWidth = (self.bounds.width - CGFloat(maxCol - 1) * margin) / CGFloat(maxCol)
        let itemHeight = itemWidth
        
        var lastView : UIView?
        for i in 0 ..< subviews.count {
            let row = i / maxCol
            let col = i % maxCol
            let x = (itemWidth + margin) * CGFloat(col)
            let y = (itemHeight + margin) * CGFloat(row)
            let view = subviews[i]
            view.snp.makeConstraints { make in
                make.top.equalTo(y)
                make.left.equalTo(x)
                make.size.equalTo(CGSize(width: itemWidth, height: itemHeight)).priority(.high)
            }
            lastView = view
        }
        
        lastView?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().priority(.high)
        }
    }
    
    @objc func addBtnClicked() {
        checkoutAlbomPrivacy()
    }
    
    private func checkoutAlbomPrivacy() {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.openPhotoAlbom()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(with: "This feature requires you to authorize this app to open the PhotoAlbom service\nHow to set it: open phone Settings -> Privacy -> PhotoAlbom service")
                    }
                }
            }
        case .authorized:
            openPhotoAlbom()
        default:
            DispatchQueue.main.async {
                self.showAlert(with: "This feature requires you to authorize this app to open the PhotoAlbom service\nHow to set it: open phone Settings -> Privacy -> PhotoAlbom service")
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
    
    private func openPhotoAlbom() {
        if #available(iOS 14.0, *) {
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            config.filter = PHPickerFilter.images
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            UIApplication.shared.keyWindow?.rootViewController?.present(picker, animated: true)
        } else {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProblemPhotosView : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let img = info[.originalImage] as? UIImage else {
            return
        }
        
        APIService.standered.uploadImageService(img) { imageURL in
            self.imgUrls.append(imageURL)
            self.images.append(img)
            self.configImages()
        }
    }
}

//MARK: - PHPickerViewControllerDelegate
extension ProblemPhotosView : PHPickerViewControllerDelegate {
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if results.count > 0 {
            let result = results[0]
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if error == nil {
                    if let img = object as? UIImage {
                        APIService.standered.uploadImageService(img) { imageURL in
                            self.imgUrls.append(imageURL)
                            self.images.append(img)
                            self.configImages()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        HUD.flash(.labeledError(title: "Error", subtitle: "Please choose photo again"), delay: 2.0)
                    }
                }
            }
        }
    }
}
