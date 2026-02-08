import Foundation

protocol TriviaAPICLientProtocol {
    func fetchQuestions() async throws -> [TriviaQuestion]
}

final class ApiClient: TriviaAPICLientProtocol {
    func fetchQuestions() async throws -> [TriviaQuestion] {
        let url = URL(string: "https://opentdb.com/api.php?amount=10&type=multiple")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode(TriviaResponse.self, from: data).results
    }
}
