import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testTrackersViewControllerSnapshot() throws {
        let vc = TrackerViewController(trackerStore: StubTrackerStore())
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackersViewControllerDarkSnapshot() throws {
        let vc = TrackerViewController(trackerStore: StubTrackerStore())
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}

extension TrackerTests {
    private struct StubTrackerStore: TrackerStoreProtocol {
        var delegate: TrackerStoreDelegate?
        var numberOfTrackers: Int = 3
        var numberOfSections: Int = 2
        
        private static let category = TrackerCategory(label: "Настроение")
        private static let trackers: [[Tracker]] = [
            [
                Tracker(
                    label: "Отличное настроение",
                    emoji: "🙂",
                    color: .bunchOfSChoices[16],
                    category: category,
                    isPinned: true,
                    completedDaysCount: 5,
                    schedule: [.saturday]
                )
            ],
            [
                Tracker(
                    label: "Смута",
                    emoji: "🤔",
                    color: .bunchOfSChoices[14],
                    category: category,
                    isPinned: false,
                    completedDaysCount: 1,
                    schedule: nil
                ),
                Tracker(
                    label: "Все плохо",
                    emoji: "😪",
                    color: .bunchOfSChoices[9],
                    category: category,
                    isPinned: false,
                    completedDaysCount: 2,
                    schedule: nil
                )
            ]
        ]
        
        func numberOfRowsInSection(_ section: Int) -> Int {
            switch section {
            case 0: return 1
            case 1: return 2
            default: return 0
            }
        }
        
        func headerLabelInSection(_ section: Int) -> String? {
            switch section {
            case 0: return "Закрепленные"
            case 1: return StubTrackerStore.category.label
            default: return nil
            }
        }
        
        func tracker(at indexPath: IndexPath) -> Tracker? {
            let tracker = StubTrackerStore.trackers[indexPath.section][indexPath.item]
            return tracker
        }
        
        func addTracker(_ tracker: Tracker, with category: TrackerCategory) throws {}
        func updateTracker(_ tracker: Tracker, with data: Tracker.Data) throws {}
        func deleteTracker(_ tracker: Tracker) throws {}
        func togglePin(for tracker: Tracker) throws {}
        func loadFilteredTrackers(date: Date, searchString: String) throws {}
    }
}


