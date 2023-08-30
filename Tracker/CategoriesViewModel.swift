import Foundation

protocol CategoriesViewModelDelegate: AnyObject {
    func didUpdateCategories()
    func didSelectCategory(_ category: TrackerCategory)
}

final class CategoriesViewModel {
    weak var delegate: CategoriesViewModelDelegate?
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            delegate?.didUpdateCategories()
        }
    }
    
    private(set) var selectedCategory: TrackerCategory? = nil {
        didSet {
            guard let selectedCategory else { return }
            delegate?.didSelectCategory(selectedCategory)
        }
    }
    
    init(selectedCategory: TrackerCategory?) {
        self.selectedCategory = selectedCategory
        trackerCategoryStore.delegate = self
    }
    
    func loadCategories() {
        categories = getCategories()
    }
    
    func selectCategory(at indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
    }
    
    func deleteCategory(_ category: TrackerCategory) {
        do {
            try trackerCategoryStore.deleteCategory(category)
            loadCategories()
            if category == selectedCategory {
                selectedCategory = nil
            }
        } catch {}
    }
    
    func handleCategoryFormConfirm(data: TrackerCategory.Data) {
        if categories.contains(where: { $0.id == data.id }) {
            updateCategory(with: data)
        } else {
            addCategory(with: data.label)
        }
    }
    
    private func getCategories() -> [TrackerCategory] {
        do {
            let categories = try trackerCategoryStore.categoriesCoreData.map {
                try trackerCategoryStore.makeCategory(from: $0)
            }
            return categories
        } catch {
            return []
        }
    }
    
    private func addCategory(with label: String) {
        do {
            try trackerCategoryStore.makeCategory(with: label)
            loadCategories()
        } catch {}
    }
    
    private func updateCategory(with data: TrackerCategory.Data) {
        do {
            try trackerCategoryStore.updateCategory(with: data)
            loadCategories()
        } catch {}
    }
}

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func didUpdate() {
        categories = getCategories()
    }
}
