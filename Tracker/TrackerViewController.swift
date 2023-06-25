import UIKit

class TrackerViewController: UIViewController {
    
    let datePicker = UIDatePicker()
    
    let starImage = UIImageView(image: UIImage(named: "star"))
    
    let questionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        configPicker()
        view.addSubview(starImage)
        view.addSubview(questionLabel)
        view.addSubview(datePicker)
        makeConstraints()
        questionLabel.text = "Что будем отслеживать?"
        questionLabel.font = .systemFont(ofSize: 12, weight: .medium)
    }

    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTracker))
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configPicker() {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(changeDate), for:.editingChanged)
        datePicker.datePickerMode = .date
    }
    
    private func makeConstraints() {
        starImage.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.heightAnchor.constraint(equalToConstant: 80),
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            questionLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        
    }

    @objc func addTracker() {

    }
    
    @objc func changeDate() {
        
    }
}

