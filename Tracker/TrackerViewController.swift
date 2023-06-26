import UIKit

class TrackerViewController: UIViewController, UITextFieldDelegate {

    private let datePicker = UIDatePicker()
    private let starImage = UIImageView(image: UIImage(named: "star"))
    private let questionLabel = UILabel()
    private let searchTF = UISearchTextField()
    let cancelButton = UIButton(type: .system)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
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
        makeConstraints()
        questionLabel.text = "Что будем отслеживать?"
        questionLabel.font = .systemFont(ofSize: 12, weight: .medium)
         
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
         
//         collectionView.dataSource = self
//         collectionView.delegate = self
//         collectionView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)
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
        datePicker.addTarget(self, action: #selector(changeDate), for:.editingChanged)
    }
    
    private func makeConstraints() {
        starImage.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        searchTF.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.heightAnchor.constraint(equalToConstant: 80),
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            questionLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 143),
            searchTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
}
