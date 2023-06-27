//
//  CertificationInfoModel.swift
//  CashMore
//
//  Created by Tim on 2023/6/9.
//

struct CertificationInfoModel : HandyJSON {
    var authStatus : Bool = false
    var loanapiUserIdentity : Bool = false
    var loanapiUserBasic : Bool = false
    var loanapiUserLinkMan : Bool = false
    var loanapiUserBankCard : Bool = false
}

struct CertificationKYCModel : HandyJSON {
    var id                     : String?
    var status                 : Bool?
    var gender                 : String?
    var backImg                : String?
    var lastName               : String?
    var frontImg               : String?
    var education              : String?
    var firstName              : String?
    var middleName             : String?
    var dateOfBirth            : String?
    var aadharNumber           : String?
    var marriageStatus         : String?
    var residenceDistrict      : String?
    var residenceDetailAddress : String?
}

struct CertificationPersonalInfoModel : HandyJSON {
    var id         : String?
    var job        : String?
    var email      : String?
    var status     : String?
    var bodyImg    : String?  // whatsapp account
    var industry   : String?
    var panNumber  : String?
    var panCardImg : String?
    var paytmAccount  : String?
    var monthlySalary : String?
}

struct CertificationContactModel : HandyJSON {
    var id     : String = ""
    var status : Bool = false
    var familyName   : String = ""
    var familyNumber : String = ""
    var colleagueName   : String = ""
    var colleagueNumber : String = ""
    var brotherOrSisterName   : String = ""
    var brotherOrSisterNumber : String = ""
}

struct CertificationBankInfoModel : HandyJSON {
    var bankCardNo : String = ""
    var ifscCode   : String = ""
    var bankName   : String = ""
}
