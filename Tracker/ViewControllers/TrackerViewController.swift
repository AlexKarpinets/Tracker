import UIKit

class TrackerViewController: UIViewController {
    
    private let datePicker = UIDatePicker()
    private let textLabel = UILabel()
    private let search = UISearchBar()
    private let filterButton = UIButton(type: .system)
    private let mainSpacePlaceholderStack = UIStackView()
    private let searchSpacePlaceholderStack = UIStackView()
    private var currentDate = Date()
    private var categories = [TrackerCategory]()
    private var trackerStore: TrackerStoreProtocol
    private var completedTrackers: Set<TrackerRecord> = []
    private var editingTracker: Tracker?
    private var searchText = "" {
        didSet {
            try? trackerStore.loadFilteredTrackers(date: currentDate, searchString: searchText)
        }
    }
    
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let analyticsService = AnalyticsService()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .ypWhiteDay
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
    
    init(trackerStore: TrackerStoreProtocol) {
        self.trackerStore = trackerStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNumberOfTrackers()
        configureNavbar()
        configPicker()
        configSearch()
        configFilterButton()
        makeConstraints()
        mainSpacePlaceholderStack.configurePlaceholderStack(imageName: "star", text: NSLocalizedString("TrackerViewController.whatWeWillTrace", comment: ""))
        searchSpacePlaceholderStack.configurePlaceholderStack(imageName: "EmptyTracker", text: NSLocalizedString("TrackerViewController.nothingFound", comment: ""))
        checkMainPlaceholderVisability()
        checkPlaceholderVisabilityAfterSearch()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        trackerRecordStore.delegate = self
        trackerStore.delegate = self
        
        try? trackerStore.loadFilteredTrackers(date: currentDate, searchString: searchText)
        try? trackerRecordStore.loadCompletedTrackers(by: currentDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.report(event: .open, params: ["screen": "Main"])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: .close, params: ["screen": "Main"])
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
        navigationItem.title = NSLocalizedString("TrackerViewController.title", comment: "trackers")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .ypBlackDay
    }
    
    private func configPicker() {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .ypWhiteDay
        datePicker.tintColor = .ypBlue
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.locale = Locale(identifier: NSLocalizedString("TrackerViewController.datePicker", comment: "date"))
                if #available(iOS 13.0, *) {
                    datePicker.overrideUserInterfaceStyle = .light
                }
        datePicker.maximumDate = Date()
        datePicker.calendar = Calendar(identifier: .iso8601)
        datePicker.addTarget(self, action: #selector(changeDate), for:.valueChanged)
        currentDate = Calendar.current.startOfDay(for: datePicker.date)
    }
    
    private func configSearch() {
        search.placeholder = NSLocalizedString("TrackerViewController.search", comment: "")
        search.searchBarStyle = .minimal
        search.delegate = self
        search.tintColor = .ypBlue
    }
    
    private func configFilterButton() {
        filterButton.setTitle(NSLocalizedString("TrackerViewController.filters", comment: ""), for: .normal)
        filterButton.backgroundColor = .ypBlue
        filterButton.tintColor = .ypWhite
        filterButton.layer.cornerRadius = 16
        filterButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        analyticsService.report(event: .click, params: ["screen": "Main", "item": Items.filter.rawValue])
    }
    
    private func checkMainPlaceholderVisability() {
        let isHidden = trackerStore.numberOfTrackers == 0  && searchSpacePlaceholderStack.isHidden
        mainSpacePlaceholderStack.isHidden = !isHidden
    }
    
    private func checkNumberOfTrackers() {
        if trackerStore.numberOfTrackers == 0 {
            filterButton.isHidden = true
        } else {
            filterButton.isHidden = false
        }
    }
    
    private func checkPlaceholderVisabilityAfterSearch() {
        let isHidden = trackerStore.numberOfTrackers == 0  && search.text != ""
        searchSpacePlaceholderStack.isHidden = !isHidden
    }
    
    private func presentFormController(
        with data: Tracker.Data? = nil,
        of trackerType: TypeTrackerViewController.TrackerType,
        setAction: CreateTrackerViewController.ActionType
    ) {
        let createTrackerViewController = CreateTrackerViewController(ActionType: setAction, trackerType: trackerType, data: data)
        createTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: createTrackerViewController)
        navigationController.isModalInPresentation = false
        present(navigationController, animated: true)
    }
    
    private func makeConstraints() {
        view.backgroundColor = .ypWhiteDay
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
        analyticsService.report(event: .click, params: ["screen": "Main", "item": Items.add_track.rawValue])
    }
    
    @objc func changeDate(_ sender: UIDatePicker) {
        currentDate = Date.from(date: sender.date) ?? Date()
        do {
            try trackerStore.loadFilteredTrackers(date: currentDate, searchString: searchText)
            try trackerRecordStore.loadCompletedTrackers(by: currentDate)
        } catch {}
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
        return trackerStore.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerStore.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackerCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell, let tracker = trackerStore.tracker(at: indexPath) else {
            return UICollectionViewCell()
        }
        
        let isCompleted = completedTrackers.contains { $0.date == currentDate && $0.trackerId == tracker.id }
        let interaction = UIContextMenuInteraction(delegate: self)
        trackerCell.configure(with: tracker, days: tracker.completedDaysCount, isCompleted: isCompleted, interaction: interaction)
        trackerCell.delegate = self
        return trackerCell
    }
}

extension TrackerViewController: UICollectionViewDelegate {
}

extension TrackerViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard
            let location = interaction.view?.convert(location, to: collectionView),
            let indexPath = collectionView.indexPathForItem(at: location),
            let tracker = trackerStore.tracker(at: indexPath)
        else { return nil }
        
        return UIContextMenuConfiguration(actionProvider:  { actions in
            UIMenu(children: [
                UIAction(title: tracker.isPinned ?  NSLocalizedString("TrackerViewController.unPin", comment: "Unpin") : NSLocalizedString("TrackerViewController.pin", comment: "Pin")) { [weak self] _ in
                    try? self?.trackerStore.togglePin(for: tracker)
                },
                UIAction(title: NSLocalizedString("CategoriesViewController.edit", comment: "Edit")) { [weak self] _ in
                    let type: TypeTrackerViewController.TrackerType = tracker.schedule != nil ? .habit : .irregularEvent
                    self?.editingTracker = tracker
                    self?.presentFormController(with: tracker.data, of: type, setAction: .edit)
                    self?.analyticsService.report(event: .click, params: ["screen": "Main", "item": Items.edit.rawValue])
                },
                UIAction(title: NSLocalizedString("CategoriesViewController.delete", comment: "Delete"), attributes: .destructive) { [weak self] _ in
                    let alert = UIAlertController(
                        title: nil,
                        message: NSLocalizedString("TrackerViewController.deleteTracker", comment: "Delete tracker"),
                        preferredStyle: .actionSheet
                    )
                    let cancelAction = UIAlertAction(title: NSLocalizedString("CreateTrackerViewController.cancel", comment: "Cancel"), style: .cancel)
                    let deleteAction = UIAlertAction(title: NSLocalizedString("CategoriesViewController.delete", comment: "Delete"), style: .destructive) { [weak self] _ in
                        guard let self else { return }
                        try? trackerStore.deleteTracker(tracker)
                        self.analyticsService.report(event: .click, params: ["screen": "Main", "item": Items.delete.rawValue])
                    }
                    
                    alert.addAction(deleteAction)
                    alert.addAction(cancelAction)
                    
                    self?.present(alert, animated: true)
                }
            ])
        })
    }
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
        
        guard let label =  trackerStore.headerLabelInSection(indexPath.section) else { return UICollectionReusableView() }
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
        presentFormController(of: type, setAction: .add)
    }
}

extension TrackerViewController: CreateTrackerViewControllerDelegate {
    func didAddTracker(category: TrackerCategory, trackerToAdd: Tracker) {
        dismiss(animated: true)
        try? trackerStore.addTracker(trackerToAdd, with: category)
    }
    
    func didUpdateTracker(with data: Tracker.Data) {
        guard let editingTracker else { return }
        dismiss(animated: true)
        try? trackerStore.updateTracker(editingTracker, with: data)
        self.editingTracker = nil
    }
    
    func didTapCancelButton() {
        collectionView.reloadData()
        editingTracker = nil
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
        if let recordToRemove = completedTrackers.first(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
            try? trackerRecordStore.remove(recordToRemove)
            cell.switchAddDayButton(to: false)
            cell.decreaseCount()
        } else {
            let trackerRecord = TrackerRecord(trackerId: tracker.id, date: currentDate)
            try? trackerRecordStore.add(trackerRecord)
            cell.switchAddDayButton(to: true)
            cell.increaseCount()
        }
    }
}

extension TrackerViewController: TrackerStoreDelegate {
    func didUpdate() {
        checkNumberOfTrackers()
        collectionView.reloadData()
    }
}

extension TrackerViewController: TrackerRecordStoreDelegate {
    func didUpdateRecords(_ records: Set<TrackerRecord>) {
        completedTrackers = records
    }
}
