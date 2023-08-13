import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    var categories = [TrackerCategory]()
    private let context: NSManagedObjectContext
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        try setupCategories(with: context)
    }
    
    func categoryCD(with id: UUID) throws -> TrackerCategoryCD {
        let request = NSFetchRequest<TrackerCategoryCD>(entityName: "TrackerCategoryCD")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCD.categoryId), id.uuidString)
        let category = try context.fetch(request)
        return category[0]
    }
    
    private func makeCategory(from coreData: TrackerCategoryCD) throws -> TrackerCategory {
        guard
            let idString = coreData.categoryId,
            let id = UUID(uuidString: idString),
            let label = coreData.label
        else { throw StoreError.decodeError }
        return TrackerCategory(id: id, label: label)
    }
    
    private func setupCategories(with context: NSManagedObjectContext) throws {
        let checkRequest = TrackerCategoryCD.fetchRequest()
        let result = try context.fetch(checkRequest)
        
        guard result.count == 0 else {
            categories = try result.map({ try makeCategory(from: $0) })
            return
        }
        
        let _ = [
            TrackerCategory(label: "Домашний уют"),
            TrackerCategory(label: "Радостные мелочи"),
            TrackerCategory(label: "Самочувствие"),
            TrackerCategory(label: "Важное"),
            TrackerCategory(label: "Привычки"),
            TrackerCategory(label: "Спорт")
        ].map { category in
            let categoryCD = TrackerCategoryCD(context: context)
            categoryCD.categoryId = category.id.uuidString
            categoryCD.createdAt = Date()
            categoryCD.label = category.label
            return categoryCD
        }
        
        try context.save()
    }
}

extension TrackerCategoryStore {
    enum StoreError: Error {
        case decodeError
    }
}
