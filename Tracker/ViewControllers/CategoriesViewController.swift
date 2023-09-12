import UIKit

protocol CategoriesViewControllerDelegate: AnyObject {
    func didConfirm(_ category: TrackerCategory)
}

final class CategoriesViewController: UIViewController {
    private let categoriesView: UITableView = {
        let table = UITableView()
        table.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        table.separatorStyle = .none
        table.allowsMultipleSelection = false
        table.backgroundColor = .clear
        table.isScrollEnabled = true
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return table
    }()
    
    private let starImage = UIImageView(image: UIImage(named: "star"))
    
    private lazy var texLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .center
        label.text = NSLocalizedString("CategoriesViewController.starCombined", comment: "Combined"))
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("CategoriesViewController.addButton", comment: "Add category"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlack
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: CategoriesViewControllerDelegate?
    private let viewModel: CategoriesViewModel
    
    init(selectedCategory: TrackerCategory?) {
        viewModel = CategoriesViewModel(selectedCategory: selectedCategory)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupConstraints()
        viewModel.delegate = self
        viewModel.loadCategories()
    }
        
    @objc
    private func didTapAddButton() {
        let addCategoryViewController = CreateCategoryViewController()
        addCategoryViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addCategoryViewController)
        present(navigationController, animated: true)
    }
    
    private func editCategory(_ category: TrackerCategory) {
        let addCategoryViewController = CreateCategoryViewController(data: category.data)
        addCategoryViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addCategoryViewController)
        present(navigationController, animated: true)
    }
    
    private func deleteCategory(_ category: TrackerCategory) {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString("CreateCategoryViewController.deleteCategory", comment: "Delete category"),
            preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(title: NSLocalizedString("CreateCategoryViewController.cancel", comment: "Cancel"), style: .cancel)
        let deleteAction = UIAlertAction(title: NSLocalizedString("CreateCategoryViewController.delete", comment: "Delete"), style: .destructive) { [weak self] _ in
            self?.viewModel.deleteCategory(category)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

private extension CategoriesViewController {
    func configureViews() {
        title = NSLocalizedString("TypeTrackerViewController.parameter1", comment: "Category")
        view.backgroundColor = .ypWhite
        [categoriesView, addButton, texLabel, starImage].forEach { view.addSubview($0) }
        
        categoriesView.dataSource = self
        categoriesView.delegate = self
        
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        texLabel.translatesAutoresizingMaskIntoConstraints = false
        starImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            categoriesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoriesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoriesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoriesView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16),
            addButton.leadingAnchor.constraint(equalTo: categoriesView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: categoriesView.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            texLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            texLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            texLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            starImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            starImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -386),
            starImage.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let categoryCell = tableView.dequeueReusableCell(
            withIdentifier: CategoryCell.identifier) as? CategoryCell else { return UITableViewCell() }
        let category = viewModel.categories[indexPath.row]
        let isSelected = viewModel.selectedCategory == category
        var position: ListOfItems.Position
        switch indexPath.row {
        case 0:
            position = viewModel.categories.count == 1 ? .alone : .first
        case viewModel.categories.count - 1:
            position = .last
        default:
            position = .middle
        }
        categoryCell.configure(with: category.label,
                               isSelected: isSelected,
                               position: position)
        
        return categoryCell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ListOfItems.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCategory(at: indexPath)
    }
}

extension CategoriesViewController: CategoriesViewModelDelegate {
    func didUpdateCategories() {
        if viewModel.categories.isEmpty {
            starImage.isHidden = false
            texLabel.isHidden = false
        } else {
            starImage.isHidden = true
            texLabel.isHidden = true
        }
        categoriesView.reloadData()
    }
    
    func didSelectCategory(_ category: TrackerCategory) {
        delegate?.didConfirm(category)
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let category = viewModel.categories[indexPath.row]
        
        return UIContextMenuConfiguration(actionProvider:  { _ in
            UIMenu(children: [
                UIAction(title: NSLocalizedString("CategoriesViewController.edit", comment: "Edit")) { [weak self] _ in
                    self?.editCategory(category)
                },
                UIAction(title: NSLocalizedString("CategoriesViewController.delete", comment: "Delete"), attributes: .destructive) { [weak self] _ in
                    self?.deleteCategory(category)
                }
            ])
        })
    }
}

extension CategoriesViewController: CreateCategoryViewControllerDelegate {
    func didConfirm(_ data: TrackerCategory.Data) {
        viewModel.handleCategoryFormConfirm(data: data)
        dismiss(animated: true)
    }
}
