import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func didUpdate()
}

protocol TrackerStoreProtocol {
    var numberOfTrackers: Int { get }
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func headerLabelInSection(_ section: Int) -> String?
    func tracker(at indexPath: IndexPath) -> Tracker?
    func addTracker(_ tracker: Tracker, with category: TrackerCategory) throws
}

final class TrackerStore: NSObject {
    
    weak var delegate: TrackerStoreDelegate?
    
    private let context: NSManagedObjectContext
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCD> = {
        let fetchRequest = NSFetchRequest<TrackerCD>(entityName: "TrackerCD")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCD.category?.categoryId, ascending: true),
            NSSortDescriptor(keyPath: \TrackerCD.createdAt, ascending: true)
        ]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category",
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    func makeTracker(from coreData: TrackerCD) throws -> Tracker {
        guard
            let idString = coreData.trackerId,
            let id = UUID(uuidString: idString),
            let label = coreData.label,
            let emoji = coreData.emoji,
            let colorHEX = coreData.colorHEX,
            let completedDaysCount = coreData.records
        else { throw StoreError.decodeError }
        let color = UIColorMarshalling.deserialize(hexString: colorHEX)
        let scheduleString = coreData.schedule
        let schedule = WeekDay.decode(from: scheduleString)
        return Tracker(
            id: id,
            label: label,
            emoji: emoji,
            color: color!,
            completedDaysCount: completedDaysCount.count,
            schedule: schedule
        )
    }
    
    func getTrackerCD(by id: UUID) throws -> TrackerCD? {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCD.trackerId), id.uuidString
        )
        try fetchedResultsController.performFetch()
        return fetchedResultsController.fetchedObjects?.first
    }
    
    func loadFilteredTrackers(date: Date, searchString: String) throws {
        var predicates = [NSPredicate]()
        
        let weekdayIndex = Calendar.current.component(.weekday, from: date)
        let iso860WeekdayIndex = weekdayIndex > 1 ? weekdayIndex - 2 : weekdayIndex + 5
        
        var regex = ""
        for index in 0..<7 {
            if index == iso860WeekdayIndex {
                regex += "1"
            } else {
                regex += "."
            }
        }
        
        predicates.append(NSPredicate(
            format: "%K == nil OR (%K != nil AND %K MATCHES[c] %@)",
            #keyPath(TrackerCD.schedule),
            #keyPath(TrackerCD.schedule),
            #keyPath(TrackerCD.schedule), regex
        ))
        
        if !searchString.isEmpty {
            predicates.append(NSPredicate(
                format: "%K CONTAINS[cd] %@",
                #keyPath(TrackerCD.label), searchString
            ))
        }
        
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        try fetchedResultsController.performFetch()
        
        delegate?.didUpdate()
    }
}


extension TrackerStore {
    enum StoreError: Error {
        case decodeError
    }
}

extension TrackerStore: TrackerStoreProtocol {
    var numberOfTrackers: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func headerLabelInSection(_ section: Int) -> String? {
        guard let trackerCD = fetchedResultsController.sections?[section].objects?.first as? TrackerCD else { return nil }
        return trackerCD.category?.label ?? nil
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker? {
        let trackerCD = fetchedResultsController.object(at: indexPath)
        do {
            let tracker = try makeTracker(from: trackerCD)
            return tracker
        } catch {
            return nil
        }
    }
    
    func addTracker(_ tracker: Tracker, with category: TrackerCategory) throws {
        let categoryCD = try trackerCategoryStore.categoryCD(with: category.id)
        let trackerCD = TrackerCD(context: context)
        trackerCD.trackerId = tracker.id.uuidString
        trackerCD.createdAt = Date()
        trackerCD.label = tracker.label
        trackerCD.emoji = tracker.emoji
        trackerCD.colorHEX = UIColorMarshalling.serialize(color: tracker.color)
        trackerCD.schedule = WeekDay.code(tracker.schedule)
        trackerCD.category = categoryCD
        try context.save()
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
