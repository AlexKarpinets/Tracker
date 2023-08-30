import UIKit

protocol CreateCategoryViewControllerDelegate: AnyObject {
    func didConfirm(_ data: TrackerCategory.Data)
}

final class CreateCategoryViewController: UIViewController {
    private lazy var textField: UITextField = {
        let textField = TextField(placeholder: "Введите название категории")
        textField.addTarget(self, action: #selector(didChangedTextField), for: .editingChanged)
        return textField
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypGray
        button.setTitleColor(.ypWhite, for: .normal)
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    weak var delegate: CreateCategoryViewControllerDelegate?
    private var data: TrackerCategory.Data
    private var isConfirmButtonEnabled: Bool = false {
        willSet {
            confirmButton.backgroundColor = newValue ? .ypBlack : .ypGray
            confirmButton.isEnabled = newValue ? true : false
        }
    }
    
    init(data: TrackerCategory.Data = TrackerCategory.Data()) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
        textField.text = data.label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureConstraints()
    }
    
    @objc
    private func didChangedTextField(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            data.label = text
            isConfirmButtonEnabled = true
        } else {
            isConfirmButtonEnabled = false
        }
    }
    
    @objc
    private func didTapButton() {
        delegate?.didConfirm(data)
    }
}

private extension CreateCategoryViewController {
    func configureView() {
        title = "Новая категория"
        view.backgroundColor = .ypWhite
        [textField, confirmButton].forEach { view.addSubview($0) }
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: ListOfItems.height)
        ])
    }
}
