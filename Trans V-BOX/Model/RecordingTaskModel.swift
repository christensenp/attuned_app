// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let recordingTaskModel = try? newJSONDecoder().decode(RecordingTaskModel.self, from: jsonData)

import Foundation

// MARK: - RecordingTaskModel
struct RecordingTaskModel: MKJSONModel {
    let status: Bool
    let code: JSONAny
    let message: String
    let data: RecordingData?
}

struct RecordingData: MKJSONModel {
    let taskList: [RecordingTask]?
    let recCount: JSONAny?
    enum CodingKeys: String, CodingKey {
        case taskList
        case recCount
    }
}

// MARK: - Datum
struct RecordingTask: MKJSONModel {
    let id, contentType, content, gender: String?
    let duration, contentOrder: Int?
    let genderFrequencyData: [GenderFrequencyData]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case contentType, gender, content, duration, contentOrder, genderFrequencyData
    }
}

// MARK: - GenderFrequencyDatum
struct GenderFrequencyData: Codable {
    let id: String?
    let gender: String?
    let idealMinFrequency, idealMaxFrequency: JSONAny?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case gender, idealMinFrequency, idealMaxFrequency
    }
}


// MARK: - UserRecordingsModel
class UserRecordingsModel: MKJSONModel {
    let status: Bool
    let code: JSONAny
    let message: String
    var data: [Recordings]?
}

// MARK: - Datum
class Recordings: MKJSONModel {
    let id, userID, gender, recordingTaskID: String?
    var recordingName, recordingContentName: String?
    let recordingURL, recordingContent: String?
    let avgFrequency: JSONAny?
    let createdAt: String?
    let minFrequency: JSONAny?
    let genderFrequencyData: [GenderFrequencyData]?
    let maxFrequency: JSONAny?
    var isPlaying: Bool?
    var isLoading: Bool?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case recordingTaskID = "recordingTaskId"
        case recordingName
        case recordingContentName
        case recordingContent
        case recordingURL = "recordingUrl"
        case avgFrequency
        case createdAt
        case gender
        case genderFrequencyData
        case minFrequency
        case maxFrequency
        case isPlaying
    }
}


class SaveRecordingModel: MKJSONModel {
    let status: Bool
    let code: JSONAny
    let message: String
    var data: Recordings?
}
