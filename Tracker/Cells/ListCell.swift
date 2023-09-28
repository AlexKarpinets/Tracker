import UIKit

final class ListCell: UITableViewCell {
    
    private lazy var listItem = ListOfItems()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGrayThree
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 2
        stack.axis = .vertical
        return stack
    }()
    
    private let chooseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Arrow"), for: .normal)
        button.tintColor = .ypGrayThree
        return button
    }()
    
    static let identifier = "ListCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(label: String, value: String?, position: ListOfItems.Position) {
        listItem.configure(with: position)
        nameLabel.text = label
        
        if let value {
            valueLabel.text = value
        }
    }
}

private extension ListCell {
    func configureViews() {
        selectionStyle = .none
        [listItem, chooseButton, labelsStack].forEach { contentView.addSubview($0) }
        labelsStack.addArrangedSubview(nameLabel)
        labelsStack.addArrangedSubview(valueLabel)
        
        listItem.translatesAutoresizingMaskIntoConstraints = false
        chooseButton.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            listItem.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listItem.topAnchor.constraint(equalTo: contentView.topAnchor),
            listItem.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listItem.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            labelsStack.leadingAnchor.constraint(equalTo: listItem.leadingAnchor, constant: 16),
            labelsStack.centerYAnchor.constraint(equalTo: listItem.centerYAnchor),
            labelsStack.trailingAnchor.constraint(equalTo: listItem.trailingAnchor, constant: -56),
            chooseButton.centerYAnchor.constraint(equalTo: listItem.centerYAnchor),
            chooseButton.trailingAnchor.constraint(equalTo: listItem.trailingAnchor, constant: -24),
            chooseButton.widthAnchor.constraint(equalToConstant: 8),
            chooseButton.heightAnchor.constraint(equalToConstant: 12),
        ])
    }
}
