import UIKit

struct Tracker: Identifiable {
    let id: UUID
    let label: String
    let emoji: String
    let color: UIColor
    let category: TrackerCategory
    let isPinned: Bool
    let completedDaysCount: Int
    let schedule: [WeekDay]?

    init(id: UUID = UUID(), label: String, emoji: String, color: UIColor, category: TrackerCategory, isPinned: Bool, completedDaysCount: Int, schedule: [WeekDay]?) {
         self.id = id
         self.label = label
         self.emoji = emoji
         self.color = color
         self.category = category
         self.completedDaysCount = completedDaysCount
         self.isPinned = isPinned
         self.schedule = schedule
     }
    
    init(tracker: Tracker) {
        self.id = tracker.id
        self.label = tracker.label
        self.emoji = tracker.emoji
        self.color = tracker.color
        self.category = tracker.category
        self.completedDaysCount = tracker.completedDaysCount
        self.isPinned = tracker.isPinned
        self.schedule = tracker.schedule
    }
    
    init(data: Data) {
        guard let emoji = data.emoji, let color = data.color, let category = data.category else { fatalError() }
        
        self.id = UUID()
        self.label = data.label
        self.emoji = emoji
        self.color = color
        self.category = category
        self.completedDaysCount = data.completedDaysCount
        self.isPinned = data.isPinned
        self.schedule = data.schedule
    }
    
    var data: Data {
        Data(label: label, emoji: emoji, color: color, category: category, completedDaysCount: completedDaysCount, schedule: schedule)
    }
}

extension Tracker {
    struct Data {
        var label: String = ""
        var emoji: String? = nil
        var color: UIColor? = nil
        var category: TrackerCategory? = nil
        var completedDaysCount: Int = 0
        var isPinned: Bool = false
        var schedule: [WeekDay]? = nil
    }
}
