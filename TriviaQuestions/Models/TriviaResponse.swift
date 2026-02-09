import Foundation
struct TriviaResponse: Decodable {
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Decodable, Identifiable, Hashable {
    var id = UUID()
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]

    private enum CodingKeys: String, CodingKey {
        case type, difficulty, category, question, correct_answer, incorrect_answers
    }

    func decoded() -> TriviaQuestion {
        TriviaQuestion(
            id: id,
            type: type.decodedHTML,
            difficulty: difficulty.decodedHTML,
            category: category.decodedHTML,
            question: question.decodedHTML,
            correct_answer: correct_answer.decodedHTML,
            incorrect_answers: incorrect_answers.map { $0.decodedHTML }
        )
    }
}
