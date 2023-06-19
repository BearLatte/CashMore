//
//  ADJustTrackTool.swift
//  CashMore
//
//  Created by Tim on 2023/6/19.
//

import Adjust
import FacebookCore

class ADJustTrackTool {
    static func point(name: String) {
        Adjust.trackEvent(ADJEvent(eventToken: name))
    }
}


class FCTrackTool {
    static func point(name: String) {
        AppEvents.shared.logEvent(AppEvents.Name(name))
    }
}
