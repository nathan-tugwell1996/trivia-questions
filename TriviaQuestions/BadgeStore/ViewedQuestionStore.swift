import Foundation

final class ViewedQuestionsStore {
    static let shared = ViewedQuestionsStore()
    private var viewedIDs: Set<UUID> = []

    func markViewed(_ id: UUID) {
        viewedIDs.insert(id)
    }

    func hasViewed(_ id: UUID) -> Bool {
        viewedIDs.contains(id)
    }
}
