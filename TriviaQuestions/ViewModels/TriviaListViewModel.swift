import Foundation
import Combine

@MainActor
final class TriviaListViewModel: ObservableObject {
    @Published var questions: [TriviaQuestion] = []
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiClient: ApiClient
    private let viewedStore: ViewedQuestionsStore
 
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
        self.viewedStore = ViewedQuestionsStore.shared
    }

    func loadQuestions() async {
        isLoading = true
        do {
            questions = try await apiClient.fetchQuestions()
        } catch {
            errorMessage = "Failed to load questions."
        }
        isLoading = false
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
