import Foundation
import Combine

@MainActor
final class ViewedQuestionsStore: ObservableObject {
    static let shared = ViewedQuestionsStore()

    @Published private(set) var viewedIDs: Set<UUID> = []

    private init() {}

    func hasViewed(_ id: UUID) -> Bool {
        viewedIDs.contains(id)
    }

    func markViewed(_ id: UUID) {
        viewedIDs.insert(id)
    }
}
