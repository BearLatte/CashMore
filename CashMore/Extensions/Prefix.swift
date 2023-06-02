//
//  Prefix.swift
//  Prefix
//
//  Created by Tim on 2019/11/15.
//  Copyright © 2019 Tim. All rights reserved.
//

import Foundation

struct TM<Base> {
    var base: Base
    init(_ base: Base) {
        self.base = base
    }
}


protocol TMCompatible {}
extension TMCompatible {
    var tm: TM<Self> {
        set{}
        get { TM(self) }
    }
    static var tm: TM<Self>.Type {
        set {}
        get { TM<Self>.self }
    }
}
