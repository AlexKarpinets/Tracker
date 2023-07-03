import UIKit

class TrackerViewController: UIViewController {
    
    //    private var categories: [TrackerCategory] = []
    //    private var completedTrackers: [TrackerRecord] = []
    //    private var visibleCategory: [TrackerCategory] = []
    
    private let datePicker = UIDatePicker()
    private let image = UIImageView(image: UIImage(named: "Star"))
    private let textLabel = UILabel()
    private let searchTF = UISearchTextField()
    private let cancelButton = UIButton(type: .system)
    private let filterButton = UIButton(type: .system)
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout())
    
    private let params = UICollectionView.GeometricParams(cellCount: 2,
                                                          leftInset: 16,
                                                          rightInset: 16,
                                                          topInset: 8,
                                                          bottomInset: 16,
                                                          height: 148,
                                                          cellSpacing: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        configPicker()
        makeConstraints()
        textLabel.text = "Что будем отслеживать?"
        textLabel.font = .systemFont(ofSize: 12, weight: .medium)
        textLabel.isHidden = true
        image.isHidden = true
        
        searchTF.placeholder = "Поиск"
        searchTF.textColor = .black
        searchTF.layer.cornerRadius = 10
        searchTF.layer.masksToBounds = true
        searchTF.clearButtonMode = .never
        searchTF.delegate = self
        searchTF.rightView = cancelButton
        searchTF.rightViewMode = .whileEditing
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        filterButton.setTitle("Фильтры", for: .normal)
        filterButton.backgroundColor = .ypBlue
        filterButton.tintColor = .ypWhite
        filterButton.layer.cornerRadius = 16
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "Header")
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
        datePicker.addTarget(self, action: #selector(changeDate), for:.valueChanged)
    }
    
    private func makeConstraints() {
        image.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        searchTF.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        [image, textLabel, searchTF, cancelButton, filterButton, collectionView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 80),
            image.heightAnchor.constraint(equalToConstant: 80),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 143),
            searchTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cancelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: searchTF.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTF.topAnchor, constant: 64),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    
    @objc func addTracker() {
        let typeTrackerVC = TypeTrackerViewController()
                let navigationController = UINavigationController(rootViewController: typeTrackerVC)
                present(navigationController, animated: true)
    }
    
    @objc func changeDate() {
        //        visibleCategory = categories.map {category in
        //
        //        }
    }
    
    @objc func cancelButtonTapped() {
        searchTF.text = nil
        searchTF.resignFirstResponder()
        
    }
}

extension TrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTF.resignFirstResponder()
        
    }
    
    
}

extension TrackerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath) as? TrackerCell else { return UICollectionViewCell() }
        cell.emodjiLabel.text = "🍔"
        cell.nameTrackerLabel.text = "Ходить в лес"
        return cell
    }
}

extension TrackerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "Header",
            for: indexPath) as? SupplementaryView else { return UICollectionReusableView() }
        headerView.titleLabel.text = "Домашний уют"
        headerView.titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
        return headerView
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
                        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        UIEdgeInsets(top: params.topInset,
                     left: params.leftInset,
                     bottom: params.bottomInset,
                     right: params.rightInset)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView,
                                             viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                                             at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}
