//
//  ContactModel.swift
//  CashMore
//
//  Created by Tim on 2023/6/10.
//

import Foundation


struct ContactModel : Selectionable {
    var isSelected: Bool
    
    var displayText: String
    
    var name : String
    
    var phoneNumber : String
    
    init(name: String, phone: String) {
        self.name = name
        self.phoneNumber = phone
        self.isSelected = false
        self.displayText = "\(name)-\(phone)"
    }
}
