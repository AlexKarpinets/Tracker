import UIKit

final class TypeTrackerViewController: UIViewController {
    
    private let habitChoiceButton = UIButton(type: .system)
    private let eventButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        makeConstraints()
    }
    
    private func makeConstraints() {
        view.addSubview(habitChoiceButton)
        view.addSubview(eventButton)
        
        habitChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            habitChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitChoiceButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitChoiceButton.heightAnchor.constraint(equalToConstant: 60),
            habitChoiceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventButton.centerXAnchor.constraint(equalTo: habitChoiceButton.centerXAnchor),
            eventButton.topAnchor.constraint(equalTo: habitChoiceButton.bottomAnchor, constant: 16),
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    private func configUI () {
        view.backgroundColor = .ypWhite
        
        title = "Создание трекера"
        
        habitChoiceButton.setTitle("Привычка", for: .normal)
        habitChoiceButton.backgroundColor = .ypBlack
        habitChoiceButton.tintColor = .ypWhite
        habitChoiceButton.layer.cornerRadius = 16
        eventButton.setTitle("Нерегулярные событие", for: .normal)
        eventButton.backgroundColor = .ypBlack
        eventButton.tintColor = .ypWhite
        eventButton.layer.cornerRadius = 16
    }
}
