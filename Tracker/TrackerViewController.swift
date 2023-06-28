import UIKit

class TrackerViewController: UIViewController, UITextFieldDelegate {
    
    private let datePicker = UIDatePicker()
    private let starImage = UIImageView(image: UIImage(named: "star"))
    private let questionLabel = UILabel()
    private let searchTF = UISearchTextField()
    private let cancelButton = UIButton(type: .system)
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let params = UICollectionView.GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, topInset: 8, bottomInset: 16, height: 148, cellSpacing: 10)
    
    
    //    private var posts: [Post] = []
    //    private var filteredPosts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        configPicker()
        view.addSubview(starImage)
        view.addSubview(questionLabel)
        view.addSubview(searchTF)
        view.addSubview(datePicker)
        view.addSubview(cancelButton)
        view.addSubview(collectionView)
        makeConstraints()
        questionLabel.text = "Что будем отслеживать?"
        questionLabel.font = .systemFont(ofSize: 12, weight: .medium)
        questionLabel.isHidden = true
        starImage.isHidden = true
        
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardTrackerCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTracker))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configPicker() {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.tintColor = .ypBlue
        datePicker.addTarget(self, action: #selector(changeDate), for:.editingChanged)
    }
    
    private func makeConstraints() {
        starImage.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        searchTF.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.heightAnchor.constraint(equalToConstant: 80),
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            questionLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 143),
            searchTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cancelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: searchTF.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTF.topAnchor, constant: 34),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    
    @objc func addTracker() {
        
    }
    
    @objc func changeDate() {
        
    }
    
    @objc func cancelButtonTapped() {
        searchTF.text = nil
        searchTF.resignFirstResponder()
        
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CardTrackerCell else {return UICollectionViewCell()}
        cell.emodjiLabel.text = "asd"
        cell.nameTrackerLabel.text = "sadasd"
        return cell
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        UIEdgeInsets(top: params.topInset, left: params.leftInset, bottom: params.bottomInset, right: params.rightInset)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        0
    }
}
