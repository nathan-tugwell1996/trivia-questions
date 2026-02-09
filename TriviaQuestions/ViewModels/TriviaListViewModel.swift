import Foundation
import Combine

@MainActor
final class TriviaListViewModel: ObservableObject {
    @Published var questions: [TriviaQuestion] = []
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var debugMessage: String?

    private let apiClient: TriviaAPICLientProtocol
    private let viewedStore: ViewedQuestionsStore
 
    init(apiClient: TriviaAPICLientProtocol) {
        self.apiClient = apiClient
        self.viewedStore = ViewedQuestionsStore.shared
    }

    func loadQuestions() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let fetched = try await apiClient.fetchQuestions()
            questions = fetched.map { $0.decoded() }
            debugMessage = "Loaded \(questions.count) questions"
        } catch {
            errorMessage = "Failed to load questions: \(error.localizedDescription)"
            debugMessage = "Load failed: \(error)"
        }
    }

    var filteredQuestions: [TriviaQuestion] {
        guard !searchText.isEmpty else { return questions }
        return questions.filter {
            $0.question.localizedCaseInsensitiveContains(searchText)
        }
    }

    func hasViewed(_ question: TriviaQuestion) -> Bool {
        viewedStore.hasViewed(question.id)
    }
}
