import UIKit

final class CreateTrackerViewController: UIViewController {
    
    
    private var nameTrackerTextField = UITextField()
    private let categoryButton = UIButton()
    private let scheduleButton = UIButton()
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let parametersTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        return table
    }()
    
    private var parametersTableViewTopConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        makeConstraints()
        parametersTableView.delegate = self
        parametersTableView.dataSource = self
    }
    
    private func makeConstraints() {
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        parametersTableView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        [nameTrackerTextField, parametersTableView, buttonsStack].forEach { view.addSubview($0) }

        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(createButton)
        
        parametersTableViewTopConstraint = parametersTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 24)
        parametersTableViewTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            nameTrackerTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTrackerTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            parametersTableView.leadingAnchor.constraint(equalTo: nameTrackerTextField.leadingAnchor),
            parametersTableView.trailingAnchor.constraint(equalTo: nameTrackerTextField.trailingAnchor),
            parametersTableView.heightAnchor.constraint(equalToConstant: 2 *  ListOfItems.height),
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configUI() {
        title = "Новая привычка"
        view.backgroundColor = .ypWhite
        
        nameTrackerTextField.placeholder = "Введите название трекера"
        nameTrackerTextField.layer.cornerRadius = 10
        nameTrackerTextField.backgroundColor = .ypGrayTwo
        
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.backgroundColor = .ypGrayThree
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        createButton.isEnabled = false
        
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        

    }
    
    @objc func didTapCreateButton() {
    }
    
    @objc func didTapCancelButton() {
    }
}

extension CreateTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listCell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier) as? ListCell
        else { return UITableViewCell() }
        return listCell
    }
}

// MARK: - UITableViewDelegate
extension CreateTrackerViewController: UITableViewDelegate {

       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           ListOfItems.height
       }
   }
