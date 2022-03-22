// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let lessonModel = try? newJSONDecoder().decode(LessonModel.self, from: jsonData)

//import Foundation
//
//// MARK: - LessonModel
//class LessonModel: MKJSONModel {
//    let status: Bool
//    let code: JSONAny
//    let message: String
//    var data: LessonsData?
//}
//
//// MARK: - DataClass
//class LessonsData: MKJSONModel {
//    var lessons: [Lesson]?
//}
//
//// MARK: - Lesson
//class Lesson: MKJSONModel {
//    let lessonID, name, homeWorkName: String?
//    let totalTime, homeWorktotalTime: Int?
//    var lessonContents: [LessonContent]?
//    var isEnabled, isFeedBack, isCompleted: Bool?
//    enum CodingKeys: String, CodingKey {
//        case lessonID = "lessonId"
//        case name, homeWorkName, totalTime, homeWorktotalTime, lessonContents, isEnabled, isCompleted, isFeedBack
//    }
//}
//
//// MARK: - LessonContent
//class LessonContent: MKJSONModel {
//    let id: String
//    let isDeleted: Bool?
//    let contentType: String?
//    let contentText: String?
//    let duration, contentOrder: Int?
//    let contentURL: String?
//    var isFinished: Bool = false
//
//    enum CodingKeys: String, CodingKey {
//        case isDeleted, contentType, contentText, duration, contentOrder
//        case contentURL = "contentUrl"
//        case id = "_id"
//    }
//}


import Foundation

// MARK: - Welcome
struct LessonModel: MKJSONModel {
    let status: Bool
    let code: Int
    let message: String
    var data: LessonsData?
}

// MARK: - DataClass
struct LessonsData: MKJSONModel {
    var lessons: [Lesson]?
}

// MARK: - Lesson
struct Lesson: MKJSONModel {
    let lessonID, name: String?
    let totalTime: Int?
    let isDeleted: Bool?
    var lessonContents: [LessonContent]?
    let homeWorktotalTime: Int?
    let homeWorkName: String?
    var isEnabled, isCompleted, isFeedBack: Bool?

    enum CodingKeys: String, CodingKey {
        case lessonID = "lessonId"
        case name, totalTime, isDeleted, lessonContents, homeWorktotalTime, homeWorkName, isEnabled, isCompleted, isFeedBack
    }
}

// MARK: - LessonContent
struct LessonContent: MKJSONModel {
    let isDeleted: Bool?
    let contentType: String?
    let id: String
    let contentText: String?
    let contentOrder: Int?
    let contentURL: String?
    let duration: JSONAny?
    var isFinished: Bool?

    enum CodingKeys: String, CodingKey {
        case isDeleted, contentType
        case id = "_id"
        case contentText, contentOrder
        case contentURL = "contentUrl"
        case duration
    }
}



