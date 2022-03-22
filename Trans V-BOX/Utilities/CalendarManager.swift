//
//  CalendarManager.swift
//  Trans V-BOX
//
//  Created by Gourav on 21/04/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import EventKit

class CalendarManager: NSObject {
    
    static let shared = CalendarManager()
    private let eventStore = EKEventStore()
    
    func addEventToCalendar(title: String, startDate: Date, endDate: Date, isAllDay: Bool, rule: String, completion: @escaping ((_ eventIdentifier: String?, _ error: Error?) -> Void)) {
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: self.eventStore)
                event.title = title
                event.isAllDay = isAllDay
                event.startDate = startDate
                event.endDate = endDate
                if let rule = self.getRepeatValue(rule) {
                    event.recurrenceRules = [rule]
                }
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                do {
                    try self.eventStore.save(event, span: .thisEvent)
                } catch let e {
                    completion(nil, e)
                    return
                }
                completion(event.eventIdentifier, nil)
            } else {
                completion(nil, error)
            }
            
        })
    }
    
    
    private func getEvents() -> [CallNotificaion] {
        if let data = UserDefaults.standard.value(forKey: UserDefaultKey.events) as? Data, let events = try? JSONDecoder().decode([CallNotificaion].self, from: data) {
            return events
        }
        return []
    }
    
    func updateEvent(previousName: String, newName: String) {
        var events = self.getEvents()
        if let index = events.firstIndex(where: {$0.recordingName == previousName}) {
            self.updateEvent(eventIdentifier: events[index].eventIdentifier, title: newName)
            let update = CallNotificaion(recordingName: newName, eventIdentifier: events[index].eventIdentifier)
            events[index] = update
            let data = try? JSONEncoder().encode(events)
            UserDefaults.standard.setValue(data, forKey: UserDefaultKey.events)
        }
    }
    
    func removeEvent(recordingName: String) {
        var events = self.getEvents()
        if let index = events.firstIndex(where: {$0.recordingName == recordingName}) {
            self.removeEvent(eventIdentifier: events[index].eventIdentifier)
            events.remove(at: index)
            let data = try? JSONEncoder().encode(events)
            UserDefaults.standard.setValue(data, forKey: UserDefaultKey.events)
        }
    }
    
    func removeEvents() {
        for event in self.getEvents() {
            self.removeEvent(eventIdentifier: event.eventIdentifier)
        }
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.events)
    }
    
    private func updateEvent(eventIdentifier: String, title: String) {
        if let event = eventStore.event(withIdentifier: eventIdentifier) {
            event.title = title
            try? eventStore.save(event, span: EKSpan.futureEvents)
        }
    }
    
    private func removeEvent(eventIdentifier: String) {
        if let event = eventStore.event(withIdentifier: eventIdentifier) {
            try? eventStore.remove(event, span: EKSpan.futureEvents)
        }
    }
    
    private func getRepeatValue (_ option : String) -> EKRecurrenceRule? {
        var rule: EKRecurrenceRule?
        switch option {
        case StringConstants.everyDay:
            rule = EKRecurrenceRule(recurrenceWith: EKRecurrenceFrequency.daily, interval: 1, end: nil)
        case StringConstants.everyWeek:
            rule = EKRecurrenceRule(recurrenceWith: EKRecurrenceFrequency.weekly, interval: 1, end: nil)
        case StringConstants.everyMonth:
            rule = EKRecurrenceRule(recurrenceWith: EKRecurrenceFrequency.monthly, interval: 1, end: nil)
        case StringConstants.everyYear:
            rule = EKRecurrenceRule(recurrenceWith: EKRecurrenceFrequency.yearly, interval: 1, end: nil)
        default:
            rule = nil
        }
        return rule
    }
    
}
