//
//  API.swift
//  CashMore
//
//  Created by Tim on 2023/6/7.
//

import Foundation

struct APIItem : APIProtocol {
    var headers: [String : String]? = {
        var header : [String : String] = [:]
        header["lang"] = "id"
        header["token"] = Constants.token
        guard let data = try? JSONSerialization.data(withJSONObject: Constants.deviceInfo),
              let deviceInfoStr = String(data: data, encoding: .utf8) else {
            return header
        }
        
        header["deviceInfo"] = deviceInfoStr
        return header
    }()
    
    
    var url: String { API.DOMIN + URLPath}
    
    var description: String
    
    var extra: String?
    
    var method: ApiHTTPMethod
    
    private let URLPath : String
    
    init(_ path: String, desc: String, extra: String? = nil, method: ApiHTTPMethod = .post) {
        self.URLPath = path
        self.description = desc
        self.extra = extra
        self.method = method
    }
    
    init(_ path: String, method: ApiHTTPMethod) {
        self.init(path, desc: "", extra: nil, method: method)
    }
}

struct API {
    static var DOMIN = "http://8.215.46.156:1060"
    
    struct Home {
        static var productList = APIItem("/PZJqjz/Ypleh", desc: "before login product list")
    }
    
    struct Cerification {
        
    }
    
    struct Login {
        
    }
    
    struct Me {
        
    }
    
    struct Feedback {
        
    }
}
