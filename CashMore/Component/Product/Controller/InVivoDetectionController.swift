//
//  InVivoDetectionController.swift
//  CashMore
//
//  Created by Tim on 2023/6/13.
//

import UIKit
import AVFoundation

class InVivoDetectionController: BaseViewController {
    
    var selectedPhoto: ((_ image: UIImage?) -> Void)?
    
    override func configUI() {
        super.configUI()
        title = "Detail"
        view.backgroundColor = Constants.pureWhite
        
        let indicatorLabel = UILabel()
        indicatorLabel.text = "Please keep all faces in the viewfinder and must upload clear photos."
        indicatorLabel.font = Constants.pingFangSCRegularFont(16)
        indicatorLabel.textColor = Constants.themeColor
        indicatorLabel.numberOfLines = 0
        indicatorLabel.textAlignment = .center
        view.addSubview(indicatorLabel)
        indicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.left.equalTo(25)
            make.right.equalTo(-25)
        }
        
        let bigCircle = UIView()
        bigCircle.backgroundColor = Constants.pureWhite
        bigCircle.layer.borderWidth = 1
        bigCircle.layer.borderColor = Constants.themeColor.cgColor
        view.addSubview(bigCircle)
        bigCircle.snp.makeConstraints { make in
            make.left.equalTo(26)
            make.right.equalTo(-26)
            make.height.equalTo(bigCircle.snp.width)
            make.centerY.equalToSuperview()
        }
        bigCircle.layoutIfNeeded()
        bigCircle.layer.cornerRadius = bigCircle.bounds.width * 0.5
        
        let smallCircle = UIView()
        smallCircle.backgroundColor = Constants.pureWhite
        smallCircle.layer.borderWidth = 8
        smallCircle.layer.borderColor = Constants.themeColor.cgColor
        view.addSubview(smallCircle)
        smallCircle.snp.makeConstraints { make in
            make.left.equalTo(bigCircle).offset(18)
            make.right.equalTo(bigCircle).offset(-18)
            make.height.equalTo(smallCircle.snp.width)
            make.centerY.equalTo(bigCircle)
        }
        smallCircle.layoutIfNeeded()
        smallCircle.layer.cornerRadius = smallCircle.bounds.width * 0.5
        smallCircle.layer.masksToBounds = true
        
        view.addSubview(shutterButton)
        shutterButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(retryBtn)
        retryBtn.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.left.equalTo(25)
            make.right.equalTo(view.snp.centerX).offset(-2)
            make.height.equalTo(50)
        }
        retryBtn.addTarget(self, action: #selector(retryTakePhoto), for: .touchUpInside)
        
        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.centerX).offset(2)
            make.right.equalTo(-25)
            make.height.equalTo(50)
        }
        submitBtn.addTarget(self, action: #selector(submitPhoto), for: .touchUpInside)
        
        layoutBtn(isAnimation: false)
        
        previewLayer.backgroundColor = UIColor.black.cgColor
        smallCircle.layer.addSublayer(previewLayer)
        previewLayer.frame = smallCircle.bounds
        
        checkCameraPermissions()
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
    }
    
    private var session : AVCaptureSession?
    private let output  : AVCapturePhotoOutput = AVCapturePhotoOutput()
    private let previewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    private lazy var shutterButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(UIImage.tm.createImage(Constants.themeColor), for: .normal)
        btn.setImage(R.image.camera_big_white(), for: .normal)
        btn.layer.cornerRadius = 30
        btn.layer.masksToBounds = true
        btn.alpha = 0.1
        return btn
    }()
    
    private lazy var retryBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(UIImage.tm.createImage(Constants.themeDarkColor), for: .normal)
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        btn.setTitle("Retry", for: .normal)
        btn.setTitleColor(Constants.pureWhite, for: .normal)
        btn.titleLabel?.font = Constants.pingFangSCMediumFont(18)
        btn.alpha = 0.1
        return btn
    }()
    
    private lazy var submitBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(UIImage.tm.createImage(Constants.themeColor), for: .normal)
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        btn.setTitle("Submit", for: .normal)
        btn.setTitleColor(Constants.pureWhite, for: .normal)
        btn.titleLabel?.font = Constants.pingFangSCMediumFont(18)
        btn.alpha = 0.1
        return btn
    }()
    
    private var currentTakedImage : UIImage?
    
    private enum LayoutButtonType {
        case shutter, select
    }
}

extension InVivoDetectionController {
    private func layoutBtn(type: LayoutButtonType = .shutter, isAnimation: Bool = true) {
        switch type {
        case .shutter:
            self.shutterButton.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-(Constants.bottomSafeArea + 10 + 60))
            }
            
            self.retryBtn.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom)
            }
            
            self.submitBtn.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom)
            }
            
            if isAnimation {
                UIView.animate(withDuration: 0.25) {
                    self.shutterButton.alpha = 1
                    self.retryBtn.alpha = 0.1
                    self.submitBtn.alpha = 0.1
                    self.view.layoutIfNeeded()
                }
            } else {
                self.shutterButton.alpha = 1
                self.retryBtn.alpha = 0.1
                self.submitBtn.alpha = 0.1
            }
        case .select:
            self.shutterButton.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom)
            }
            
            self.retryBtn.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-(Constants.bottomSafeArea + 10 + 50))
            }
            
            self.submitBtn.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-(Constants.bottomSafeArea + 10 + 50))
            }
            UIView.animate(withDuration: 0.25) {
                self.shutterButton.alpha = 0.1
                self.retryBtn.alpha = 1
                self.submitBtn.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        case .authorized:
            setupCamera()
        default: break
        }
    }
    
    private func setupCamera() {
        HUD.show(.labeledProgress(title: nil, subtitle: "loading"))
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                DispatchQueue.global().async {
                    session.startRunning()
                    DispatchQueue.main.async {
                        HUD.hide()
                    }
                }
                self.session = session
            } catch {
                HUD.flash(.labeledError(title: "Camera Error", subtitle: nil))
                Constants.debugLog(error.localizedDescription)
            }
        }
    }
    
    @objc func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    @objc func retryTakePhoto() {
        layoutBtn(type: .shutter)
        DispatchQueue.global().async {
            self.session?.startRunning()
        }
    }
    
    @objc func submitPhoto() {
        // upload photo
        selectedPhoto?(currentTakedImage)
        goBack()
    }
}

extension InVivoDetectionController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            HUD.flash(.labeledError(title: "Take Photo Error", subtitle: nil), delay: 2.0)
            layoutBtn(type: .shutter)
            session?.startRunning()
            return
        }
        session?.stopRunning()
        layoutBtn(type: .select)
        currentTakedImage = image
    }
}
