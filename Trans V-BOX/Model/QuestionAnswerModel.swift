// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let questionAnswerModel = try? newJSONDecoder().decode(QuestionAnswerModel.self, from: jsonData)

import Foundation

// MARK: - QuestionAnswerModel
struct QuestionAnswerModel: MKJSONModel {
    let status: Bool?
    let code: Int?
    let message: String?
    var data: ScreenData?
}

// MARK: - DataClass
struct ScreenData: MKJSONModel {
    let screen1, screen3, screen6, screen5: [Screen]?
    let screen2, screen4, screen7: [Screen]?

    enum CodingKeys: String, CodingKey {
        case screen1 = "Screen1"
        case screen3 = "Screen3"
        case screen6 = "Screen6"
        case screen5 = "Screen5"
        case screen2 = "Screen2"
        case screen4 = "Screen4"
        case screen7 = "Screen7"
    }
}

// MARK: - Screen
struct Screen: MKJSONModel {
    var question: Question?
    let questionID: String?
    let answers: [Answers]?
    let screen: String?

    enum CodingKeys: String, CodingKey {
        case question
        case questionID = "questionId"
        case answers, screen
    }
}

// MARK: - Answer
struct Answers: MKJSONModel {
    let questionID, userID: String?
    let otherAnswer: String?
    let questionOptionID: String?
    enum CodingKeys: String, CodingKey {
        case questionID = "questionId"
        case userID = "userId"
        case otherAnswer
        case questionOptionID = "questionOptionId"
    }
}
// MARK: - Question
struct Question: MKJSONModel {
    let question: String?
    let questionType: String?
    let minimumValue: JSONAny?
    let maximumValue: JSONAny?
    var midValue: JSONAny?
    let maxAllowedAnswers, maxCharacter: Int?
    let isDeleted: Bool?
    var questionOptions: [QuestionOption]?
}

// MARK: - QuestionOption
struct QuestionOption: MKJSONModel {
    let value: String?
    let optionImg: String?
    let optionDesc, questionID, questionOptionID: String?
    let sortOrder: Int?
    var isAnswer: Bool = false
    enum CodingKeys: String, CodingKey {
        case value, optionImg, optionDesc
        case questionID = "questionId"
        case questionOptionID = "questionOptionId"
        case sortOrder
    }
}

enum OptionImg: String, MKJSONModel {
    case empty = ""
    case genderNonConfirmingJpg = "genderNonConfirming.jpg"
    case nonBinaryJpg = "nonBinary.jpg"
    case transFemaleJpg = "transFemale.jpg"
    case transMaleJpg = "transMale.jpg"
}

enum QuestionType: String {
    case mcq = "mcq"
    case radio = "radio"
    case text = "text"
}
