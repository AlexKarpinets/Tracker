import UIKit

class TrackerViewController: UIViewController {
    
    private let datePicker = UIDatePicker()
    private let textLabel = UILabel()
    private let search = UISearchBar()
    private let filterButton = UIButton(type: .system)
    private let mainSpacePlaceholderStack = UIStackView()
    private let searchSpacePlaceholderStack = UIStackView()
    private var currentDate = Date()
    private var categories: [TrackerCategory] = TrackerCategory.mockData {
        didSet {
            checkMainPlaceholderVisability()
        }
    }
    private var completedTrackers: Set<TrackerRecord> = []
    private var searchText = ""
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .ypWhite
        view.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.identifier
        )
        view.register(
            TrackerCategoryNames.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        return view
    }()
    
    private let params = UICollectionView.GeometricParams(cellCount: 2,
                                                          leftInset: 16,
                                                          rightInset: 16,
                                                          topInset: 8,
                                                          bottomInset: 16,
                                                          height: 148,
                                                          cellSpacing: 10)
    
    private var visibleCategories: [TrackerCategory] {
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        
        var result = [TrackerCategory]()
        for category in categories {
            let trackersByDay = category.trackers.filter { tracker in
                guard let schedule = tracker.schedule else { return true }
                return schedule.contains(WeekDay.allCases[weekday > 1 ? weekday - 2 : weekday + 5])
            }
            
            if searchText.isEmpty && !trackersByDay.isEmpty {
                result.append(TrackerCategory(label: category.label, trackers: trackersByDay))
            } else {
                let filteredTrackers = trackersByDay.filter { tracker in
                    tracker.label.lowercased().contains(searchText.lowercased())
                }
                
                if !filteredTrackers.isEmpty {
                    result.append(TrackerCategory(label: category.label, trackers: filteredTrackers))
                }
            }
        }
        
        if result.isEmpty {
            filterButton.isHidden = true
        } else {
            filterButton.isHidden = false
        }
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        configPicker()
        configSearch()
        configFilterButton()
        makeConstraints()
        mainSpacePlaceholderStack.configurePlaceholderStack(imageName: "star", text: "Что будем отслеживать?")
        searchSpacePlaceholderStack.configurePlaceholderStack(imageName: "EmptyTracker", text: "Ничего не найдено")
        checkMainPlaceholderVisability()
        checkPlaceholderVisabilityAfterSearch()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTracker))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configPicker() {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.tintColor = .ypBlue
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.locale = Locale(identifier: "ru_Ru")
        datePicker.calendar.firstWeekday = 2
        datePicker.calendar = Calendar(identifier: .iso8601)
        datePicker.addTarget(self, action: #selector(changeDate), for:.valueChanged)
    }
    
    private func configSearch() {
        search.placeholder = "Поиск"
        search.searchBarStyle = .minimal
        search.delegate = self
    }
    
    private func configFilterButton() {
        filterButton.setTitle("Фильтры", for: .normal)
        filterButton.backgroundColor = .ypBlue
        filterButton.tintColor = .ypWhite
        filterButton.layer.cornerRadius = 16
        filterButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
    }
    
    private func checkMainPlaceholderVisability() {
        let isHidden = visibleCategories.isEmpty && searchSpacePlaceholderStack.isHidden
        mainSpacePlaceholderStack.isHidden = !isHidden
    }
    
    private func checkPlaceholderVisabilityAfterSearch() {
        let isHidden = visibleCategories.isEmpty && search.text != ""
        searchSpacePlaceholderStack.isHidden = !isHidden
    }
    
    private func makeConstraints() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        search.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        mainSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        searchSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        [textLabel, search, filterButton, collectionView, mainSpacePlaceholderStack, searchSpacePlaceholderStack, datePicker].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1083),
            textLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            datePicker.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            search.topAnchor.constraint(equalTo: view.topAnchor, constant: 143),
            search.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            search.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            search.heightAnchor.constraint(equalToConstant: 36),
            collectionView.topAnchor.constraint(equalTo: search.bottomAnchor, constant: 34),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainSpacePlaceholderStack.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.495),
            mainSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchSpacePlaceholderStack.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.495),
            searchSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func addTracker() {
        let typeTrackerVC = TypeTrackerViewController()
        typeTrackerVC.delegate = self
        let navigationController = UINavigationController(rootViewController: typeTrackerVC)
        present(navigationController, animated: true)
    }
    
    @objc func changeDate(_ sender: UIDatePicker) {
        guard let currentDate = Date.from(date: sender.date) else { return }
        collectionView.reloadData()
    }
    
    @objc func cancelButtonTapped() {
        search.text = nil
        search.resignFirstResponder()
    }
}

extension TrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search.resignFirstResponder()
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        checkMainPlaceholderVisability()
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackerCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.identifier,
            for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let daysCount = completedTrackers.filter { $0.trackerId == tracker.id }.count
        let isCompleted = completedTrackers.contains { $0.date == currentDate && $0.trackerId == tracker.id }
        trackerCell.configure(with: tracker, days: daysCount, isCompleted: isCompleted)
        trackerCell.delegate = self
        return trackerCell
    }
}

extension TrackerViewController: UICollectionViewDelegate {
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableSpace = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableSpace / params.cellCount
        return CGSize(width: cellWidth, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: params.leftInset, bottom: 16, right: params.rightInset)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? TrackerCategoryNames
        else { return UICollectionReusableView() }
        
        let label = visibleCategories[indexPath.section].label
        view.configure(with: label)
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}

extension TrackerViewController: TypeTrackerViewControllerDelegate {
    func didSelectTracker(with type: TypeTrackerViewController.TrackerType) {
        dismiss(animated: true)
        let createTrackerVC = CreateTrackerViewController(type: type)
        createTrackerVC.delegate = self
        let navigationController = UINavigationController(rootViewController: createTrackerVC)
        present(navigationController, animated: true)
    }
}

extension TrackerViewController: CreateTrackerViewControllerDelegate {
    func didTapConfirmButton(categoryLabel: String, trackerToAdd: Tracker) {
        dismiss(animated: true)
        guard let categoryIndex = categories.firstIndex(where: { $0.label == categoryLabel }) else { return }
        let updatedCategory = TrackerCategory(
            label: categoryLabel,
            trackers: categories[categoryIndex].trackers + [trackerToAdd])
        categories[categoryIndex] = updatedCategory
        collectionView.reloadData()
    }
    
    func didTapCancelButton() {
        dismiss(animated: true)
    }
}

extension TrackerViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ search: UISearchBar) -> Bool {
        checkPlaceholderVisabilityAfterSearch()
        search.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBar(_ search: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        collectionView.reloadData()
        checkPlaceholderVisabilityAfterSearch()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchText = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        collectionView.reloadData()
        checkPlaceholderVisabilityAfterSearch()
    }
}

extension TrackerViewController: TrackerCellDelegate {
    func didTapCompleteButton(of cell: TrackerCell, with tracker: Tracker) {
        let trackerRecord = TrackerRecord(trackerId: tracker.id, date: currentDate)
        
        if completedTrackers.contains(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
            completedTrackers.remove(trackerRecord)
            cell.switchAddDayButton(to: false)
            cell.decreaseCount()
        } else {
            completedTrackers.insert(trackerRecord)
            cell.switchAddDayButton(to: true)
            cell.increaseCount()
        }
    }
}
