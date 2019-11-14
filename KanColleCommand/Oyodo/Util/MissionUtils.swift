//
// Created by CC on 2019-03-31.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum MissionRequireType {
    case NONE,
         BATTLE, //出击
         EXPEDITION, //远征
         REPAIR, //入渠
         SUPPLY, //补给
         PRACTICE, //演习
         CREATE_ITEM, //开发
         CREATE_SHIP, //建造
         DESTROY_ITEM, //废弃
         DESTROY_SHIP, //解体
         REMODEL_SLOT, //改修
         POWER_UP //强化
}

class MissionData {

    public let description: String
    public let require: Int
    public let type: MissionRequireType
    public let processor: (AnyObject) -> Int

    init(description: String, require: Int, type: MissionRequireType,
         processor: @escaping (AnyObject) -> Int) {
        self.description = description
        self.require = require
        self.type = type
        self.processor = processor
    }

}

func getMissionData(byId: Int) -> MissionData? {
    var data: MissionData? = nil
    switch (byId) {

            /** ==========出击类========== */
    case 201:
        data = MissionData(description: "获得胜利一次", require: 1, type: MissionRequireType.BATTLE,
                processor: {
                    bean in
                    var count = 0
                    if let battleBean = bean as? IBattleResult {
                        if (isBattleWin(bean: battleBean)) {
                            count = 1
                        }
                    }
                    return count
                })
        break
    case 216:
        data = MissionData(description: "进行战斗1次", require: 1, type: MissionRequireType.BATTLE,
                processor: {
                    bean in
                    return 1
                })
        break
    case 210:
        data = MissionData(description: "进行战斗10次", require: 10, type: MissionRequireType.BATTLE,
                processor: {
                    bean in
                    return 1
                })
        break
    case 218:
        data = MissionData(description: "击沉补给舰3艘", require: 3, type: MissionRequireType.BATTLE,
                processor: {
                    bean in
                    var count = 0
                    count += Battle.instance.enemyList.filter { (ship: Ship) -> Bool in
                        (ship.type == 15) && isShipSink(ship: ship)
                    }.count
                    count += Battle.instance.subEnemyList.filter { (ship: Ship) -> Bool in
                        ship.type == 15 && isShipSink(ship: ship)
                    }.count
                    return count
                })
        break
    case 226:
        data = MissionData(description: "2-1～2-5 BOSS点获得胜利5次", require: 5, type: MissionRequireType.BATTLE,
                processor: {
                    bean in
                    var count = 0
                    if let battleBean = bean as? IBattleResult {
                        if (isBattleWin(bean: battleBean)
                                && (Battle.instance.area == 2)
                                && (Battle.instance.nodeType == BossBattle)) {
                            count = 1
                        }
                    }
                    return count
                })
        break
    case 230:
        data = MissionData(description: "击沉潜水艇6艘", require: 6, type: MissionRequireType.BATTLE,
                processor: {
                    bean in
                    var count = 0
                    count += Battle.instance.enemyList.filter { (ship: Ship) -> Bool in
                        (ship.type == 13) && isShipSink(ship: ship)
                    }.count
                    count += Battle.instance.subEnemyList.filter { (ship: Ship) -> Bool in
                        ship.type == 13 && isShipSink(ship: ship)
                    }.count
                    return count
                })
        break

            /** ==========演习类========== */
    case 303:
        data = MissionData(description: "进行演习3次", require: 3, type: MissionRequireType.PRACTICE,
                processor: {
                    bean in
                    return 1
                })
        break
    case 304:
        data = MissionData(description: "演习胜利5次", require: 5, type: MissionRequireType.PRACTICE,
                processor: {
                    bean in
                    var count = 0
                    if let practiceBean = bean as? PracticeResult {
                        if (isPracticeWin(bean: practiceBean)) {
                            count = 1
                        }
                    }
                    return count
                })
        break

            /** ==========远征类========== */
    case 402:
        data = MissionData(description: "远征成功3次", require: 3, type: MissionRequireType.EXPEDITION,
                processor: {
                    bean in
                    var count = 0
                    if let expeditionBean = bean as? MissionResult {
                        if (isExpeditionSuccess(bean: expeditionBean)) {
                            count = 1
                        }
                    }
                    return count
                })
        break
    case 403:
        data = MissionData(description: "远征成功10次", require: 10, type: MissionRequireType.EXPEDITION,
                processor: {
                    bean in
                    var count = 0
                    if let expeditionBean = bean as? MissionResult {
                        if (isExpeditionSuccess(bean: expeditionBean)) {
                            count = 1
                        }
                    }
                    return count
                })
        break

            /** ==========整备类========== */
    case 503:
        data = MissionData(description: "入渠5次", require: 5, type: MissionRequireType.REPAIR,
                processor: {
                    bean in
                    return 1
                })
        break
    case 504:
        data = MissionData(description: "补给15次", require: 15, type: MissionRequireType.SUPPLY,
                processor: {
                    bean in
                    return 1
                })
        break

            /** ==========工厂类========== */
    case 605:
        data = MissionData(description: "开发1次", require: 1, type: MissionRequireType.CREATE_ITEM,
                processor: {
                    bean in
                    return 1
                })
        break
    case 606:
        data = MissionData(description: "建造1次", require: 1, type: MissionRequireType.CREATE_SHIP,
                processor: {
                    bean in
                    return 1
                })
        break
    case 607:
        data = MissionData(description: "开发3次", require: 3, type: MissionRequireType.CREATE_ITEM,
                processor: {
                    bean in
                    return 1
                })
        break
    case 608:
        data = MissionData(description: "建造3次", require: 3, type: MissionRequireType.CREATE_SHIP,
                processor: {
                    bean in
                    return 1
                })
        break
    case 609:
        data = MissionData(description: "解体2次", require: 2, type: MissionRequireType.DESTROY_SHIP,
                processor: {
                    bean in
                    return 1
                })
        break
    case 619:
        data = MissionData(description: "改修1次", require: 1, type: MissionRequireType.REMODEL_SLOT,
                processor: {
                    bean in
                    return 1
                })
        break
    case 673:
        data = MissionData(description: "废弃小口径主炮4根（计数器代表有无废弃纪录）", require: 1, type: MissionRequireType.DESTROY_ITEM,
                processor: {
                    bean in
                    //var count = 0
                    //if let b = bean as? JsonBean {
                        //count = b.params["api_slotitem_ids"]?
                                //.components(separatedBy: "%2C")
                                //.map { s in
                                    //let slotId = parse(value: s)
                                    //return Fleet.instance.slotMap[slotId]!
                                //}.filter { (slot: Slot) -> Bool in
                                    //slot.type == 1
                                //}.count ?? 0
                    //}
                    return 1 //count
                })
        break
    case 674:
        data = MissionData(description: "废弃机枪3根（计数器代表有无废弃纪录）", require: 1, type: MissionRequireType.DESTROY_ITEM,
                processor: {
                    bean in
                    //var count = 0
                    //if let b = bean as? JsonBean {
                        //count = b.params["api_slotitem_ids"]?
                                //.components(separatedBy: "%2C")
                                //.map { s in
                                    //let slotId = parse(value: s)
                                    //return Fleet.instance.slotMap[slotId]!
                                //}.filter { (slot: Slot) -> Bool in
                                    //slot.type == 21
                                //}.count ?? 0
                    //}
                    return 1 //count
                })
        break

            /** ==========强化类========== */
    case 702:
        data = MissionData(description: "近代化改修成功2次", require: 2, type: MissionRequireType.POWER_UP,
                processor: {
                    bean in
                    var count = 0
                    if let b = bean as? PowerUp {
                        if (isPowerUpSuccess(bean: b)) {
                            count = 1
                        }
                    }
                    return count
                })
        break
    default:
        break
    }
    return data
}

func setMissionProgress(bean: JsonBean, type: MissionRequireType) {
    do {
        let questMap = try Mission.instance.questMap.value()
        questMap.values
                .filter { quest in
                    quest.type == type
                }
                .forEach { quest in
                    setQuestCounter(quest: quest, bean: bean)
                }
        Mission.instance.questMap.onNext(questMap)
    } catch {
        print("Got error in setMissionProgress")
    }
}

func setQuestCounter(quest: Quest, bean: JsonBean) {
    let increment = getMissionData(byId: quest.id)?.processor(bean) ?? 0
    quest.current = min(quest.max, quest.current + increment)
}

func getQuestIndicatorColor(type: Int) -> UIColor {
    var result = UIColor(hexString: "#A1A1A1")
    switch (type) {
    case 1:
        result = UIColor(hexString: "#2C8D50")
        break
    case 2:
        result = UIColor(hexString: "#E14A4A")
        break
    case 3:
        result = UIColor(hexString: "#9DCD66")
        break
    case 4:
        result = UIColor(hexString: "#42BCB6")
        break
    case 5:
        result = UIColor(hexString: "#E6CB6F")
        break
    case 6:
        result = UIColor(hexString: "#825940")
        break
    case 7:
        result = UIColor(hexString: "#CFA9E0")
        break
    default:
        break
    }
    return result
}

func isBattleWin(bean: IBattleResult?) -> Bool {
    let rank = bean?.api_data?.api_win_rank ?? ""
    return (rank == "S" || rank == "A" || rank == "B")
}

func isShipSink(ship: Ship) -> Bool {
    return (ship.hp() <= 0)
}

func isPracticeWin(bean: PracticeResult?) -> Bool {
    let rank = bean?.api_data?.api_win_rank ?? ""
    return (rank == "S" || rank == "A" || rank == "B")
}

func isExpeditionSuccess(bean: MissionResult?) -> Bool {
    return (bean?.api_data?.api_clear_result == 1)
}

func isPowerUpSuccess(bean: PowerUp?) -> Bool {
    return (bean?.api_data?.api_powerup_flag == 1)
}
