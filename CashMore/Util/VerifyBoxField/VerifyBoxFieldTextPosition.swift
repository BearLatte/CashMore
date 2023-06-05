//
//  VerifyBoxFieldTextPosition.swift
//  VerifyBoxField
//
//  Created by Tim on 2023/6/3.
//

import UIKit

class VerifyBoxFieldTextPosition: UITextPosition {
    let offset : Int
    init(offset: Int) {
        self.offset = offset
        super.init()
    }
}

extension VerifyBoxFieldTextPosition {
    func copy(with zone: NSZone? = nil) -> Any {
        return VerifyBoxFieldTextPosition(offset: self.offset)
    }
}
