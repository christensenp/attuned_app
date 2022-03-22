//
//  ReminderModel.swift
//  Trans V-BOX
//
//  Created by Gourav on 12/05/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import Foundation

// MARK: - ReminderModel
struct ReminderModel: MKJSONModel {
    let status: Bool
    let code: JSONAny
    let message: String
    let data: [Reminder]?
}

// MARK: - Datum
struct Reminder: MKJSONModel {
    let id: String?
    let isDeleted: Bool?
    let repeatType: String?
    let reminderTime: JSONAny?
    let status: Bool?
    let createdAt, updatedAt, userID: String?
    let v: JSONAny?
    let isAllDay: Bool?
    let reminderName: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case isDeleted, reminderTime, repeatType, status, createdAt, updatedAt
        case userID = "userId"
        case v = "__v"
        case reminderName
        case isAllDay
    }
}
