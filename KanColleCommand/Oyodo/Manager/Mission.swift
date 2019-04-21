//
// Created by CC on 2019-02-13.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift

class Mission {

    static let instance = Mission()

    var questMap: BehaviorSubject<Dictionary<Int, Quest>>
    private var lastUpdate: Date

    init() {
        questMap = BehaviorSubject.init(value: Dictionary())
        lastUpdate = Mission.getNowTime()
    }

    func isSameDay() -> Bool {
        var now = Calendar.current
        if let zone = TimeZone(secondsFromGMT: 32400) {
            now.timeZone = zone
        }
        return now.isDateInToday(lastUpdate)
    }

    private class func getNowTime() -> Date {
        let zone = NSTimeZone(forSecondsFromGMT: 32400)
        return Date().addingTimeInterval(TimeInterval(zone.secondsFromGMT))
    }

}