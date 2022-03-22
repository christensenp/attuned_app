// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let lessonModel = try? newJSONDecoder().decode(LessonModel.self, from: jsonData)

import Foundation

// MARK: - LessonModel
class HomeWorkModel: MKJSONModel {
    let status: Bool
    let code: JSONAny
    let message: String
    var data: HomeworkData?
}

// MARK: - DataClass
class HomeworkData: MKJSONModel {
    let totalTime: Int?
    let name: String?
    var homework: [Homework]?
}

// MARK: - Homework
class Homework: MKJSONModel {
    let exerciseID, lessonID, name: String?
    let totalTime: Int?
    let exerciseContents: [LessonContent]?
    var isEnabled, isCompleted: Bool?

    enum CodingKeys: String, CodingKey {
        case exerciseID = "exerciseId"
        case lessonID = "lessonId"
        case name, totalTime, exerciseContents, isEnabled, isCompleted
    }
}

