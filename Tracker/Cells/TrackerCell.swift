import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapAddDayButton(of cell: TrackerCell, with tracker: Tracker)
}

final class TrackerCell: UICollectionViewCell {
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor(red: 174 / 255, green: 175 / 255, blue: 180 / 255, alpha: 0.3).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let iconView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        return view
    }()
    
    private let emoji: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let trackerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    private let daysCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        return label
    }()
    
    private lazy var addDayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .ypWhiteDay
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(didTapAddDayButton), for: .touchUpInside)
        return button
    }()
    
    static let identifier = "TrackerCell"
    weak var delegate: TrackerCellDelegate?
    private var tracker: Tracker?
    private var days = 0 {
        willSet {
            daysCountLabel.text = String.localizedStringWithFormat(
                NSLocalizedString("amountOfDays", comment: ""), newValue)
        }
    }
    private let analyticsService = AnalyticsService()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tracker = nil
        days = 0
        addDayButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addDayButton.layer.opacity = 1
    }
    
    func configure(with tracker: Tracker, days: Int, isCompleted: Bool, interaction: UIInteraction) {
        self.tracker = tracker
        self.days = days
        cardView.backgroundColor = tracker.color
        cardView.addInteraction(interaction)
        emoji.text = tracker.emoji
        trackerLabel.text = tracker.label
        addDayButton.backgroundColor = tracker.color
        switchAddDayButton(to: isCompleted)
    }
    
    func switchAddDayButton(to isCompleted: Bool) {
        if isCompleted {
            addDayButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            addDayButton.layer.opacity = 0.3
        } else {
            addDayButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addDayButton.layer.opacity = 1
        }
    }
    
    func increaseCount() {
        days += 1
    }
    
    func decreaseCount() {
        days -= 1
    }
    
    @objc
    private func didTapAddDayButton() {
        analyticsService.report(event: .click, params: ["screen" : "Main", "item" : Items.track.rawValue])
        guard let tracker else { return }
        delegate?.didTapAddDayButton(of: self, with: tracker)
    }
}

private extension TrackerCell {
    func configureViews() {
        [cardView, trackerLabel, daysCountLabel, addDayButton].forEach { contentView.addSubview($0) }
        [iconView, emoji, trackerLabel].forEach { cardView.addSubview($0) }
        cardView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        emoji.translatesAutoresizingMaskIntoConstraints = false
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        daysCountLabel.translatesAutoresizingMaskIntoConstraints = false
        addDayButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            iconView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            emoji.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            trackerLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            trackerLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            trackerLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            daysCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysCountLabel.centerYAnchor.constraint(equalTo: addDayButton.centerYAnchor),
            daysCountLabel.trailingAnchor.constraint(equalTo: addDayButton.leadingAnchor, constant: -8),
            addDayButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            addDayButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addDayButton.widthAnchor.constraint(equalToConstant: 34),
            addDayButton.heightAnchor.constraint(equalTo: addDayButton.widthAnchor),
        ])
    }
}
