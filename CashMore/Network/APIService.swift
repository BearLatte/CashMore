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
                Constants.debugLog(error.localizedDescription)
            }
    }
    
    func ocrService(imgData: Data, type: OCRType, success: @escaping (_ ocrResult : HandyJSON) -> Void) {
        HUD.show(.labeledProgress(title: nil, subtitle: "loading"))
        var ossParams : OSSParameters = OSSParameters()
        var imgUrl : String = ""
        var currentModel : HandyJSON = CardFrontModel()
        var errorMsg : String?
        
        let dispatchQueue = DispatchQueue(label: "serial")
        let semaphore = DispatchSemaphore(value: 0)
        
        dispatchQueue.async {
            NTTool.fetch(API.Certification.ossParams, parameters: Constants.configParameters([:]))
                .success { networkModel in
                    if networkModel.code != 1 {
                        errorMsg = networkModel.msg
                    } else {
                        guard let params = OSSParameters.deserialize(from: networkModel.response.cont) else {
                            return
                        }
                        ossParams = params
                        semaphore.signal()
                    }
                }
                .failed { error in
                    errorMsg = error.localizedDescription
                }
        }
        
        dispatchQueue.async {
            semaphore.wait()
            let credential = OSSFederationCredentialProvider {
                let token = OSSFederationToken()
                token.tAccessKey = ossParams.credentials.accessKeyId
                token.tSecretKey = ossParams.credentials.accessKeySecret
                token.tToken     = ossParams.credentials.securityToken
                token.expirationTimeInGMTFormat = ossParams.credentials.expiration
                return token
            }
            let client = OSSClient(endpoint: ossParams.url, credentialProvider: credential)

            let put = OSSPutObjectRequest()
            put.bucketName = ossParams.bucket
            put.objectKey  = "\(Date().timeIntervalSince1970).jpg"
            put.uploadingData = imgData
            put.callbackParam["callbackBody"] = "test"
            put.uploadProgress = { bytesSent, totalByteSent, totalBytesExpectedToSend in
                Constants.debugLog("本次发送: \(bytesSent), 已发送了：\(totalByteSent), 总大小:\(totalBytesExpectedToSend)")
            }
            let putTask = client.putObject(put)
            
            putTask.continue({ (task) -> Any? in
                if task.error != nil {
                    errorMsg = task.error?.localizedDescription
                }
                let result = task.result as? OSSCallBackResult
                Constants.debugLog(result)
                semaphore.signal()
                return nil
            }).waitUntilFinished()
        }
        
//        Optional(OSSResult<0x28230d080> : {httpResponseCode: 200, requestId: 64832A44B537853732037C5E, httpResponseHeaderFields: {
//           Connection = "keep-alive";
//           "Content-Length" = 0;
//           "Content-MD5" = "SzSsykJOEeY0JFYMFqbHOg==";
//           Date = "Fri, 09 Jun 2023 13:33:58 GMT";
//           Etag = "\"4B34ACCA424E11E63424560C16A6C73A\"";
//           Server = AliyunOSS;
//           "x-oss-hash-crc64ecma" = 10697682633216275923;
//           "x-oss-request-id" = 64832A44B537853732037C5E;
//           "x-oss-server-time" = 13;
//       }, local_crc64ecma: (null)})
        
//        Optional(OSSResult<0x283885640> : {httpResponseCode: 200, requestId: 64832A79B739BA3233F39D78, httpResponseHeaderFields: {
//           Connection = "keep-alive";
//           "Content-Length" = 0;
//           "Content-MD5" = "l6R6uEIbsD36Dp3DvLz4IA==";
//           Date = "Fri, 09 Jun 2023 13:34:50 GMT";
//           Etag = "\"97A47AB8421BB03DFA0E9DC3BCBCF820\"";
//           Server = AliyunOSS;
//           "x-oss-hash-crc64ecma" = 7508083511777698834;
//           "x-oss-request-id" = 64832A79B739BA3233F39D78;
//           "x-oss-server-time" = 18;
//       }, local_crc64ecma: (null)})
        
        dispatchQueue.async {
            semaphore.wait()
            
            Constants.debugLog("测试一些数据")
//            var modelType : HandyJSON.Type = CardFrontModel.self
//            switch type {
//            case .cardFront:
//                modelType = CardFrontModel.self
//            case .cardBack:
//                modelType = CardBackModel.self
//            case .panFront:
//                modelType = PanFrontModel.self
//            }
//
//            fetchModel(api: API.Certification.ocr, parameters: ["imgUrl" : imgUrl, "type" : type.rawValue],type: modelType) { model in
//                currentModel = model
//                semaphore.signal()
//            }
        }
    }
    
    private func go2login() {
        let loginVC = LoginController()
        loginVC.pattern = .present
        loginVC.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController?.present(loginVC, animated: true)
    }
}
