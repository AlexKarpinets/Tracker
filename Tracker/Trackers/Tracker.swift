import UIKit

struct Tracker: Identifiable {
     let id: UUID
     let label: String
     let emoji: String
     let color: UIColor
     let schedule: [WeekDay]?

     init(id: UUID = UUID(), label: String, emoji: String, color: UIColor, schedule: [WeekDay]?) {
         self.id = id
         self.label = label
         self.emoji = emoji
         self.color = color
         self.schedule = schedule
     }
    
    init(tracker: Tracker) {
        self.id = tracker.id
        self.label = tracker.label
        self.emoji = tracker.emoji
        self.color = tracker.color
        self.schedule = tracker.schedule
    }
    
    init(data: Data) {
        guard let emoji = data.emoji, let color = data.color else { fatalError()
        }
        
        self.id = UUID()
        self.label = data.label
        self.emoji = emoji
        self.color = color
        self.schedule = data.schedule
    }
    
    var data: Data {
        Data(label: label, emoji: emoji, color: color, schedule: schedule)
    }
}

extension Tracker {
    struct Data {
        var label: String = ""
        var emoji: String? = nil
        var color: UIColor? = nil
        var schedule: [WeekDay]? = nil
    }
}
