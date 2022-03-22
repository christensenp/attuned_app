
enum ProfileStep3 {
    case header
    case options
    case optionsType
    case currentlyMyVoice
    case idealVoice
    
}


enum QuesType: String {
    case mcq = "mcq"
    case slider = "slider"
    case radio = "radio"
    case text = "text"
}

enum Lessions {
    case user
    case header
    case lessions
}

enum ContentType: String {
    case text = "text"
    case video = "video"
}

enum RecorderState {
    case recording
    case stopped
    case denied
}

enum VideoStatus {
    case playing
    case pause
    case finished
}

enum PushType: String {
    case saveRecording = "saveRecording"
    case reminder = "Reminder"
    case adminNotifications = "Admin Notifications"
}
