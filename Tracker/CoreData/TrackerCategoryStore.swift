import CoreData
import UIKit

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdate()
}

final class TrackerCategoryStore: NSObject {
    weak var delegate: TrackerCategoryStoreDelegate?
    var categoriesCoreData: [TrackerCategoryCD] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
    var categories = [TrackerCategory]()
    private let context: NSManagedObjectContext
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCD> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCD>(entityName: "TrackerCategoryCD")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCD.createdAt, ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }
    
    func categoryCD(with id: UUID) throws -> TrackerCategoryCD {
        let request = NSFetchRequest<TrackerCategoryCD>(entityName: "TrackerCategoryCD")
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCD.categoryId),
            id.uuidString)
        let category = try context.fetch(request)
        return category[0]
    }
    
    func makeCategory(from coreData: TrackerCategoryCD) throws -> TrackerCategory {
        guard
            let idString = coreData.categoryId,
            let id = UUID(uuidString: idString),
            let label = coreData.label
        else { throw StoreError.decodeError }
        return TrackerCategory(id: id,label: label)
    }
    
    @discardableResult
    func makeCategory(with label: String) throws -> TrackerCategory {
        let category = TrackerCategory(label: label)
        let categoryCD = TrackerCategoryCD(context: context)
        categoryCD.categoryId = category.id.uuidString
        categoryCD.createdAt = Date()
        categoryCD.label = category.label
        try context.save()
        return category
    }
    
    func updateCategory(with data: TrackerCategory.Data) throws {
        let category = try getCategoryCD(by: data.id)
        category.label = data.label
        try context.save()
    }
    
    func deleteCategory(_ category: TrackerCategory) throws {
        let categoryToDelete = try getCategoryCD(by: category.id)
        context.delete(categoryToDelete)
        
        try context.save()
    }
    
    private func getCategoryCD(by id: UUID) throws -> TrackerCategoryCD {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCD.categoryId),
            id.uuidString
        )
        try fetchedResultsController.performFetch()
        guard let category = fetchedResultsController.fetchedObjects?.first else { throw StoreError.fetchCategoryError }
        fetchedResultsController.fetchRequest.predicate = nil
        try fetchedResultsController.performFetch()
        return category
    }
}

extension TrackerCategoryStore {
    enum StoreError: Error {
        case decodeError, fetchCategoryError
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
