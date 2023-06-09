//
//  API.swift
//  CashMore
//
//  Created by Tim on 2023/6/7.
//

import Foundation

struct APIItem : APIProtocol {
    
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
    
    struct Certification {
        static var info = APIItem("/PZJqjz/RrKrKN/bdlcP", desc: "get the all certification info")
        static var ossParams = APIItem("/PZJqjz/RrKrKN/UHbCO", desc: "get the oss parameters")
        static var ocr  = APIItem("/PZJqjz/RrKrKN/LxUNR", desc: "OCR")
    }
    
    struct Login {
        static var sendSMS = APIItem("/PZJqjz/YDnMb", desc: "login send sms")
        static var login   = APIItem("/PZJqjz/JLPCu", desc: "login")
        static var logOut  = APIItem("/PZJqjz/YzXli", desc: "logout")
    }
    
    struct Me {
        static var userInfo = APIItem("/PZJqjz/RrKrKN/OQRvo", desc: "get user info")
    }
    
    struct Feedback {
        
    }
}
