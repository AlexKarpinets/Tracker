import UIKit

protocol TypeTrackerViewControllerDelegate: AnyObject {
    func didSelectTracker(with: TypeTrackerViewController.TrackerType)
}

final class TypeTrackerViewController: UIViewController {
    
    private lazy var  habitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle(NSLocalizedString("TypeTrackerViewController.habitButton", comment: "Habit"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var  irregularEventButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle(NSLocalizedString("TypeTrackerViewController.irregularEventButton", comment: "Irregular event"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapIrregularEventButton), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    weak var delegate: TypeTrackerViewControllerDelegate?
    
    private var labelText = ""
    private var category: String?
    private var schedule: [WeekDay]?
    private var emoji: String?
    private var color: UIColor?
    
    private var isConfirmButtonEnabled: Bool {
        labelText.count > 0 && !isValidationMessageVisible
    }
    
    private var isValidationMessageVisible = false
    private var parameters = [NSLocalizedString("TypeTrackerViewController.parameter1", comment: "Category"), NSLocalizedString("TypeTrackerViewController.parameter2", comment: "Schedule")]
    private let emojis = emojisArray
    private let colors = UIColor.bunchOfSChoices
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
    }
    
    @objc
    private func didTapHabitButton() {
        title = NSLocalizedString("TypeTrackerViewController.didTapHabitButton", comment: "New habit")
        delegate?.didSelectTracker(with: .habit)
    }
    
    @objc
    private func didTapIrregularEventButton() {
        title = NSLocalizedString("TypeTrackerViewController.didTapIrregularEventButton", comment: "New irregular event")
        delegate?.didSelectTracker(with: .irregularEvent)
    }
}

extension TypeTrackerViewController {
    enum TrackerType {
        case habit, irregularEvent
    }
}

private extension TypeTrackerViewController {
    
    func configureViews() {
        title = NSLocalizedString("TypeTrackerViewController.configureViews", comment: "Creating a tracker")
        view.backgroundColor = .ypWhite
        view.addSubview(stackView)
        stackView.addArrangedSubview(habitButton)
        stackView.addArrangedSubview(irregularEventButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
