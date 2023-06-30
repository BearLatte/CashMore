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


class FacebookTrackTool {
    static func point(name: AppEvents.Name) {
        AppEvents.shared.logEvent(name)
    }
}
