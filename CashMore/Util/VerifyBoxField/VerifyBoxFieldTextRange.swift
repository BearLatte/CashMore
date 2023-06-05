//
//  VerifyBoxFieldTextRange.swift
//  VerifyBoxField
//
//  Created by Tim on 2023/6/3.
//

import UIKit

class VerifyBoxFieldTextRange: UITextRange {
    override var start: UITextPosition {
        get {
            return _start
        }
    }
    
    override var end: UITextPosition {
        get {
            return _end
        }
    }
    
    let _start : VerifyBoxFieldTextPosition
    let _end : VerifyBoxFieldTextPosition
    
    init(start: VerifyBoxFieldTextPosition, end: VerifyBoxFieldTextPosition) {
        self._start = start
        self._end = end
        assert(start.offset <= end.offset)
        super.init()
    }
    
    convenience init?(range: NSRange) {
        if range.location == NSNotFound {
            return nil
        }
        
        let start = VerifyBoxFieldTextPosition(offset: range.location)
        let end = VerifyBoxFieldTextPosition(offset: range.location + range.length)
        self.init(start: start, end: end)
    }
}

extension VerifyBoxFieldTextRange : NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return VerifyBoxFieldTextRange(start: self._start, end: self._end)
    }
}
