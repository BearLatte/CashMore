//
//  OSSParameters.swift
//  CashMore
//
//  Created by Tim on 2023/6/9.
//

import Foundation


class OSSParameters : HandyJSON {
    var url : String = ""
    var bucket : String = ""
    var credentials: OSSCredentials = OSSCredentials()
    
    required init() {
        
    }
    
    struct OSSCredentials : HandyJSON {
        var securityToken : String = ""
        var accessKeySecret: String = ""
        var accessKeyId: String = ""
        var expiration: String = ""
    }
}
