//
//  NotificationModel.swift
//  Trans V-BOX
//
//  Created by Gourav on 01/06/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import Foundation

// MARK: - NotificationModel
struct NotificationModel: MKJSONModel {
    let status: Bool?
    let code: Int?
    let message: String?
    let data: [Notifications]?
}

// MARK: - Datum
struct Notifications: MKJSONModel {
    let id, notificationType: String?
    let isNewNotification, isRead: Bool?
    let sentTo, sentFrom, createdAt, updatedAt: String?
    let fromID, toID, message, resourceID: String?
    let title, type: String?
    let v: JSONAny?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case notificationType, isNewNotification, isRead, sentTo, sentFrom, createdAt, updatedAt
        case fromID = "fromId"
        case toID = "toId"
        case message
        case resourceID = "resourceId"
        case title, type
        case v = "__v"
    }
}

