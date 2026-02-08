import Foundation
struct TriviaResponse: Decodable {
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Decodable, Identifiable {
    var id = UUID()
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}
