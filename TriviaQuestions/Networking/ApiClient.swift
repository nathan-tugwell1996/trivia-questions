import Foundation

protocol TriviaAPICLientProtocol {
    func fetchQuestions() async throws -> [TriviaQuestion]
}

final class ApiClient: TriviaAPICLientProtocol {
    func fetchQuestions() async throws -> [TriviaQuestion] {
        let url = URL(string: "https://opentdb.com/api.php?amount=15")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            let triviaResponse = try decoder.decode(TriviaResponse.self, from: data)
            return triviaResponse.results
        } catch {
            if let body = String(data: data, encoding: .utf8) {
                _ = body.prefix(4000)
            }
            throw APIError.decodingError
        }
    }
}
