//
//  APIService.swift
//  CashMore
//
//  Created by Tim on 2023/6/8.
//

import ProgressHUD

struct APIService {
    static let standered = APIService()
    
    func fetchList<T: HandyJSON>(api: APIProtocol, type: T, listPath: String, parameters: [String : Any]? = nil, success: @escaping ([T?]) -> Void) {
        ProgressHUD.show("loading...")
        NTTool.fetch(API.Home.productList, parameters: Constants.configParameters(parameters))
            .success { networkModel in
                ProgressHUD.dismiss()
                switch networkModel.code {
                case 0:
                    Constants.debugLog("The network is failed, " + networkModel.msg)
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
                ProgressHUD.dismiss()
                Constants.debugLog(error.localizedDescription)
            }
    }

    private func go2login() {
        let loginVC = LoginController()
        loginVC.pattern = .present
        loginVC.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController?.present(loginVC, animated: true)
    }
}
