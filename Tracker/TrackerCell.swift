import UIKit

final class TrackerCell: UICollectionViewCell {
    
    let cardView = UIView()
    let iconView = UIView()
    let nameTrackerLabel = UILabel()
    let emodjiLabel = UILabel()
    let daysLabel = UILabel()
    let plusButton = UIButton(type: .custom)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        daysLabel.text = "1 day"
        cardView.backgroundColor = .blue
        cardView.layer.cornerRadius = 16
        iconView.layer.cornerRadius = 12
        iconView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        emodjiLabel.font = UIFont.systemFont(ofSize: 12)
        nameTrackerLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameTrackerLabel.numberOfLines = 0
        nameTrackerLabel.textColor = .ypWhite
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = .ypWhite
        plusButton.layer.cornerRadius = 17
        plusButton.addTarget(self, action: #selector(pressPlusButton), for: .touchUpInside)
        plusButton.backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraints () {
        [cardView, iconView, emodjiLabel, nameTrackerLabel, daysLabel, plusButton].forEach { contentView.addSubview($0) }
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        nameTrackerLabel.translatesAutoresizingMaskIntoConstraints = false
        emodjiLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            iconView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            emodjiLabel.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            emodjiLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            nameTrackerLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            nameTrackerLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            nameTrackerLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            daysLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            plusButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor),
        ])
    }
    
    @objc func pressPlusButton() {
        
    }
}
