//
//  APIService.swift
//  CashMore
//
//  Created by Tim on 2023/6/8.
//

@_exported import PKHUD
import AliyunOSSiOS

enum OCRType : String {
    case cardFront = "AADHAAR_FRONT"
    case cardBack  = "AADHAAR_BACK"
    case panFront  = "PAN_FRONT"
}

struct APIService {
    static let standered = APIService()
    
    func fetchList<T: HandyJSON>(api: APIProtocol, type: T, listPath: String, parameters: [String : Any]? = nil, success: @escaping ([T?]) -> Void) {
        DispatchQueue.main.async {
            HUD.show(.labeledProgress(title: nil, subtitle: "loading"))
        }
        
        NTTool.fetch(API.Home.productList, parameters: Constants.configParameters(parameters))
            .success { networkModel in
                HUD.hide()
                switch networkModel.code {
                case 0:
                    DispatchQueue.main.async {
                        HUD.flash(.labeledError(title: "Failed", subtitle: networkModel.msg), delay: 2.0)
                    }
                case 1:
                    guard let baseContent = networkModel.response.cont,
                          let dictList = baseContent[listPath] as? [[String : Any]],
                          let list = [T].deserialize(from: dictList) else {
                        return
                    }
                    
                    success(list)
                case -1:
                    go2login()
                default: break
                }
            }
            .failed { error in
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription), delay: 2.0)
                }
            }
    }
    
    func fetchModel<T: HandyJSON>(api: APIProtocol, parameters: [String : Any]? = nil, type: T.Type, success: @escaping ((T) -> Void)) {
        DispatchQueue.main.async {
            HUD.show(.labeledProgress(title: nil, subtitle: "loading"))
        }
        NTTool.fetch(api, parameters: Constants.configParameters(parameters))
            .success { networkModel in
                HUD.hide()
                switch networkModel.code {
                case 0:
                    DispatchQueue.main.async {
                        HUD.flash(.labeledError(title: "Failed", subtitle: networkModel.msg), delay: 2.0)
                    }
                    
                case 1:
                    Constants.debugLog(networkModel.response.cont)
                    guard let baseContent = networkModel.response.cont,
                          let model = T.deserialize(from: baseContent) else {
                        return
                    }
                    success(model)
                case -1:
                    go2login()
                default: break
                }
            }
            .failed { error in
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription), delay: 2.0)
                }
                Constants.debugLog(error.localizedDescription)
            }
    }
    
    func normalRequest(api: APIProtocol, parameters: [String : Any]? = nil, success: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            HUD.show(.labeledProgress(title: nil, subtitle: "loading"))
        }
        NTTool.fetch(api, parameters: Constants.configParameters(parameters))
            .success { networkModel in
                HUD.hide()
                switch networkModel.code {
                case 0:
                    DispatchQueue.main.async {
                        HUD.flash(.labeledError(title: "Failed", subtitle: networkModel.msg), delay: 2.0)
                    }
                case 1:
                    success()
                case -1:
                    go2login()
                default: break
                }
            }
            .failed { error in
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription), delay: 2.0)
                }
            }
    }
    
    func ocrService(imgData: Data, type: OCRType, success: @escaping (_ ocrResult : HandyJSON) -> Void) {
        DispatchQueue.main.async {
            HUD.show(.labeledProgress(title: nil, subtitle: "loading"))
        }
        var ossParams : OSSParameters = OSSParameters()
        var uploadedImgUrl : String = ""
        
        let dispatchQueue = DispatchQueue(label: "serial")
        let semaphore = DispatchSemaphore(value: 0)
        
        dispatchQueue.async {
            fetchOssParams { params in
                ossParams = params
                semaphore.signal()
            }
            
            semaphore.wait()
            uploadImageWithOssParams(imgData: imgData, params: ossParams) { imgUrl in
                uploadedImgUrl = imgUrl
                semaphore.signal()
            }
            
            semaphore.wait()
            fetchOcr(type: type, parameters: ["imgUrl" : uploadedImgUrl, "type" : type.rawValue]) { ocrModel in
                DispatchQueue.main.async {
                    HUD.hide()
                }
                switch type {
                case .cardFront:
                    (ocrModel as? CardFrontModel)?.imageUrl = uploadedImgUrl
                case .cardBack:
                    (ocrModel as? CardBackModel)?.imageUrl  = uploadedImgUrl
                case .panFront:
                    (ocrModel as? PanFrontModel)?.imageUrl  = uploadedImgUrl
                }
                
                success(ocrModel)
                semaphore.signal()
            }
        }
    }
    
    // 图片上传
    func uploadImageService(_ image: UIImage?, success: @escaping (_ imageURL: String) -> Void) {
        DispatchQueue.main.async {
            HUD.show(.labeledProgress(title: nil, subtitle: "loading"))
        }
        
        let dispatchQueue = DispatchQueue(label: "serial")
        let semaphore = DispatchSemaphore(value: 0)
        
        dispatchQueue.async {
            var ossParams : OSSParameters = OSSParameters()
            fetchOssParams { params in
                ossParams = params
                semaphore.signal()
            }
            
            semaphore.wait()
            guard let imgData = image?.tm.compressImage(maxLength: 1024 * 200) else {
                DispatchQueue.main.async {
                    HUD.flash(.label("Photo cannot be empty"), delay: 2.0)
                }
                return
            }
            uploadImageWithOssParams(imgData: imgData, params: ossParams) { imgUrl in
                semaphore.signal()
                success(imgUrl)
                DispatchQueue.main.async {
                    HUD.flash(.labeledSuccess(title: "Upload Success", subtitle: nil))
                }
            }
        }
    }
    
    // 用户人脸信息认证
    func faceVerifyService(_ image: UIImage?, success: @escaping () -> Void) {
        let dispatchQueue = DispatchQueue(label: "serial")
        let semaphore = DispatchSemaphore(value: 0)
        dispatchQueue.async {
            var imgUrl : String = ""
            uploadImageService(image) { imageURL in
                imgUrl = imageURL
                semaphore.signal()
            }
            
            semaphore.wait()
            normalRequest(api: API.Certification.faceAuth, parameters: ["livenessImg":imgUrl]) {
                success()
            }
        }
    }
}


// MARK: - Private
extension APIService {
    private func fetchOssParams(success: @escaping (OSSParameters) -> Void) {
        NTTool.fetch(API.Certification.ossParams, parameters: Constants.configParameters([:]))
            .success { networkModel in
                switch networkModel.code {
                case 0:
                    DispatchQueue.main.async {
                        HUD.flash(.labeledError(title: "Failed", subtitle: networkModel.msg), delay: 2.0)
                    }
                case 1:
                    guard let params = OSSParameters.deserialize(from: networkModel.response.cont) else {
                        return
                    }
                    success(params)
                case -1:
                    DispatchQueue.main.async {
                        self.go2login()
                    }
                default:break
                }
            }
            .failed { error in
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription), delay: 2.0)
                }
            }
    }
    
    private func uploadImageWithOssParams(imgData: Data, params: OSSParameters, success: @escaping (_ imgUrl: String) -> Void) {
        let credential = OSSFederationCredentialProvider {
            let token = OSSFederationToken()
            token.tAccessKey = params.credentials.accessKeyId
            token.tSecretKey = params.credentials.accessKeySecret
            token.tToken     = params.credentials.securityToken
            token.expirationTimeInGMTFormat = params.credentials.expiration
            return token
        }
        
        let client = OSSClient(endpoint: params.url, credentialProvider: credential)
        let put = OSSPutObjectRequest()
        put.bucketName = params.bucket
        let fullPath = "india/img/\(Date().tm.toString(format: "yyyy-MM-dd"))/\(String.tm.randomString(with: 32)).jpg"
        put.objectKey  = fullPath
        put.uploadingData = imgData
        let putTask = client.putObject(put)
        
        putTask.continue({ (task) -> Any? in
            if task.error != nil {
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: "Upload Failed", subtitle: task.error?.localizedDescription))
                }
            }
            success(fullPath)
            return nil
        }).waitUntilFinished()
    }
    
    private func fetchOcr(type: OCRType, parameters: [String : Any], success: @escaping (_ ocrModel : HandyJSON) -> Void) {
        NTTool.fetch(API.Certification.ocr, parameters: Constants.configParameters(parameters))
            .success { networkModel in
                switch networkModel.code {
                case 0:
                    DispatchQueue.main.async {
                        HUD.flash(.labeledError(title: "Failed", subtitle: networkModel.msg), delay: 2.0)
                    }
                case 1:
                    var modelType : HandyJSON.Type?
                    switch type {
                    case .cardFront:
                        modelType = CardFrontModel.self
                    case .cardBack:
                        modelType = CardBackModel.self
                    case .panFront:
                        modelType = PanFrontModel.self
                    }
                    
                    guard let model = modelType?.deserialize(from: networkModel.response.cont) else {
                        DispatchQueue.main.async {
                            HUD.flash(.label("Unknow Error"))
                        }
                        return
                    }
                    success(model)
                case -1:
                    DispatchQueue.main.async {
                        self.go2login()
                    }
                default:break
                }
            }
            .failed { error in
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription), delay: 2.0)
                }
            }
    }
    
    private func go2login() {
        let loginVC = LoginController()
        loginVC.pattern = .present
        loginVC.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController?.present(loginVC, animated: true)
    }
}
