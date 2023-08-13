import UIKit
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdateRecords(_ records: Set<TrackerRecord>)
}

final class TrackerRecordStore: NSObject {
    weak var delegate: TrackerRecordStoreDelegate?
    
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    private var completedTrackers: Set<TrackerRecord> = []
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    func add(_ newRecord: TrackerRecord) throws {
        let trackerCD = try trackerStore.getTrackerCD(by: newRecord.trackerId)
        let TrackerRecordCD = TrackerRecordCD(context: context)
        TrackerRecordCD.recordId = newRecord.id.uuidString
        TrackerRecordCD.date = newRecord.date
        TrackerRecordCD.tracker = trackerCD
        try context.save()
        completedTrackers.insert(newRecord)
        delegate?.didUpdateRecords(completedTrackers)
    }
    
    func remove(_ record: TrackerRecord) throws {
        let request = NSFetchRequest<TrackerRecordCD>(entityName: "TrackerRecordCD")
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordCD.recordId), record.id.uuidString
        )
        let records = try context.fetch(request)
        guard let recordToRemove = records.first else { return }
        context.delete(recordToRemove)
        try context.save()
        completedTrackers.remove(record)
        delegate?.didUpdateRecords(completedTrackers)
    }
    
    func loadCompletedTrackers(by date: Date) throws {
        let request = NSFetchRequest<TrackerRecordCD>(entityName: "TrackerRecordCD")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCD.date), date as NSDate)
        let recordsCoreData = try context.fetch(request)
        let records = try recordsCoreData.map { try makeTrackerRecord(from: $0) }
        completedTrackers = Set(records)
        delegate?.didUpdateRecords(completedTrackers)
    }
    
    private func makeTrackerRecord(from coreData: TrackerRecordCD) throws -> TrackerRecord {
        guard
            let idString = coreData.recordId,
            let id = UUID(uuidString: idString),
            let date = coreData.date,
            let trackerCD = coreData.tracker,
            let tracker = try? trackerStore.makeTracker(from: trackerCD)
        else { throw StoreError.decodeError }
        return TrackerRecord(id: id, trackerId: tracker.id, date: date)
    }
}

extension TrackerRecordStore {
    enum StoreError: Error {
        case decodeError
    }
}
