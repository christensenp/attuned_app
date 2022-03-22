//
//  SettingsModel.swift
//  Trans V-BOX
//
//  Created by Suraj on 4/3/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import Foundation
import UIKit

struct Settings{
    var title: String
    var isSwitchHidden: Bool
    var isArrowImageHidden: Bool
    var iconImage: UIImage
    var toggleValue: Bool
}

// MARK: - UserRecordingsModel
struct SettingsModel: MKJSONModel {
    let status: Bool
    let code: JSONAny
    let message: String
    var data: Setting?
}

// MARK: - DataClass
struct Setting: MKJSONModel {
    let id: String?
    var isPushNotificationEnabled, isCallNotificationEnabled: Bool
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case isPushNotificationEnabled, isCallNotificationEnabled
    }
}

struct CallNotificaion: MKJSONModel {
    let recordingName: String
    let eventIdentifier: String
}
