import UIKit

final class EmojiCell: UICollectionViewCell {
    // MARK: - Layout elements
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        return label
    }()
    
    // MARK: - Properties
    static let identifier = "EmojiCell"
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with label: String) {
        emojiLabel.text = label
    }
}

// MARK: - Layout methods

private extension EmojiCell {
    func configureViews() {
        contentView.addSubview(emojiLabel)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

// MARK: - implementation SelectionCellProtocol
extension EmojiCell: SelectionCellProtocol {
    func select() {
        contentView.backgroundColor = .ypGray
    }
    
    func deselect() {
        contentView.backgroundColor = .clear
    }
}
// MARK: - SelectionCellProtocol
protocol SelectionCellProtocol {
    func select()
    func deselect()
}
