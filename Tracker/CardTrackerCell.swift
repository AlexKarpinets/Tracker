import UIKit

final class CardTrackerCell: UICollectionViewCell {
    
    let nameTrackerLabel = UILabel()
    let emodjiLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .green
        contentView.addSubview(nameTrackerLabel)
        contentView.addSubview(emodjiLabel)
        nameTrackerLabel.translatesAutoresizingMaskIntoConstraints = false
        emodjiLabel.translatesAutoresizingMaskIntoConstraints = false
     
        NSLayoutConstraint.activate([
            nameTrackerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 12),
            nameTrackerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            emodjiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            emodjiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
