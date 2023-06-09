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
        HUD.show(.labeledProgress(title: nil, subtitle: "loading"))
        NTTool.fetch(API.Home.productList, parameters: Constants.configParameters(parameters))
            .success { networkModel in
                HUD.hide()
                switch networkModel.code {
                case 0:
                    HUD.flash(.labeledError(title: "Failed", subtitle: networkModel.msg), delay: 1.0)
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
                HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription), delay: 1.0)
                Constants.debugLog(error.localizedDescription)
            }
    }
    
    func fetchModel<T: HandyJSON>(api: APIProtocol, parameters: [String : Any]? = nil, type: T.Type, success: @escaping ((T) -> Void)) {
        HUD.show(.labeledProgress(title: nil, subtitle: "loading"))
        NTTool.fetch(api, parameters: Constants.configParameters(parameters))
            .success { networkModel in
                HUD.hide()
                switch networkModel.code {
                case 0:
                    HUD.flash(.labeledError(title: "Failed", subtitle: networkModel.msg), delay: 1.0)
                case 1:
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
                HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription), delay: 1.0)
                Constants.debugLog(error.localizedDescription)
            }
    }
    
    func normalRequest(api: APIProtocol, parameters: [String : Any]? = nil, success: @escaping (() -> Void)) {
        HUD.show(.labeledProgress(title: nil, subtitle: "loading"))
        NTTool.fetch(api, parameters: Constants.configParameters(parameters))
            .success { networkModel in
                HUD.hide()
                switch networkModel.code {
                case 0:
                    HUD.flash(.labeledError(title: "Failed", subtitle: networkModel.msg), delay: 1.0)
                case 1:
                    success()
                case -1:
                    go2login()
                default: break
                }
            }
            .failed { error in
                HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription), delay: 1.0)
            }
    }
    
    func ocrService(imgData: Data, type: OCRType, success: @escaping (_ ocrResult : HandyJSON) -> Void) {
        HUD.show(.labeledProgress(title: nil, subtitle: "loading"))
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
                success(ocrModel)
                semaphore.signal()
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
                        HUD.flash(.labeledError(title: "Failed", subtitle: networkModel.msg), delay: 1.0)
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
                    HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription), delay: 1.0)
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
        let fullPath = "inida/img/\(String.tm.randomString(with: 10)).jpg"
        put.objectKey  = fullPath
        put.uploadingData = imgData
        put.callbackParam["callbackBody"] = "test"
        put.uploadProgress = { bytesSent, totalByteSent, totalBytesExpectedToSend in
            Constants.debugLog("本次发送: \(bytesSent), 已发送了：\(totalByteSent), 总大小:\(totalBytesExpectedToSend)")
        }
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
                        HUD.flash(.labeledError(title: "Failed", subtitle: networkModel.msg), delay: 1.0)
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
                    HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription), delay: 1.0)
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
