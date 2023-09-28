import UIKit

final class StatisticViewController: UIViewController {
    
    private let statisticLabel = UILabel()
    private let mainSpacePlaceholderStack = UIStackView()
    private let statisticsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    var statisticViewModel: StatisticViewModel?
    private let trackerRecordStore = TrackerRecordStore()
    private let completedTrackersView = StatisticView(name: NSLocalizedString("StatisticViewController.finishedTrackers", comment: "Finished trackers"))
    private let trackerStore = TrackerStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        statisticLabel.configureLabel(
            text: (NSLocalizedString("StatisticViewController.title", comment: "")),
            addToView: view,
            ofSize: 34,
            weight: .bold
        )
        configureViews()
        makeConstraints()
        mainSpacePlaceholderStack.configurePlaceholderStack(imageName: "Error", text: (NSLocalizedString("StatisticViewController.nothingToAnalyze", comment: "")))
        statisticViewModel?.onTrackersChange = { [weak self] trackers in
            guard let self else { return }
            self.checkContent(with: trackers)
            self.setupCompletedTrackersBlock(with: trackers.count)
            checkMainPlaceholderVisability()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statisticViewModel?.viewWillAppear()
    }
    
    private func setupCompletedTrackersBlock(with count: Int) {
        completedTrackersView.setNumber(count)
    }
    
    private func checkMainPlaceholderVisability() {
        let isHidden = trackerStore.numberOfTrackers == 0
        mainSpacePlaceholderStack.isHidden = !isHidden
    }
    
    private func checkContent(with trackers: [TrackerRecord]) {
        if trackers.isEmpty {
            statisticsStack.isHidden = true
        } else {
            statisticsStack.isHidden = false
        }
    }
}

private extension StatisticViewController {
    func configureViews() {
        [statisticLabel, mainSpacePlaceholderStack, statisticsStack].forEach { view.addSubview($0) }
        statisticsStack.addArrangedSubview(completedTrackersView)
        statisticLabel.translatesAutoresizingMaskIntoConstraints = false
        mainSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        statisticsStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            statisticLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            statisticLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1083),
            mainSpacePlaceholderStack.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.495),
            mainSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statisticsStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
