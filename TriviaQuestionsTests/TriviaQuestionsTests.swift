//
//  TriviaQuestionsTests.swift
//  TriviaQuestionsTests
//
//  Created by Nathan Tugwell on 08/02/2026.
//

import XCTest
@testable import TriviaQuestions

final class TriviaQuestionsTests: XCTestCase {

    func testDecodedHTMLNamedAndNumericEntities() {
        let encoded = "The Who&#039;s eponymous line, &quot;Teenage Wasteland&quot;"
        let decoded = encoded.decodedHTML
        XCTAssertEqual(decoded, "The Who's eponymous line, \"Teenage Wasteland\"")

        let hexEncoded = "Unicode heart: &#x2665;"
        XCTAssertEqual(hexEncoded.decodedHTML, "Unicode heart: ♥")
    }

    func testViewModelFilteringAndLoad() async throws {
        struct MockClient: TriviaAPICLientProtocol {
            let questions: [TriviaQuestion]
            func fetchQuestions() async throws -> [TriviaQuestion] {
                return questions
            }
        }

        let q1 = TriviaQuestion(type: "multiple", difficulty: "easy", category: "Music", question: "Who sings?", correct_answer: "A", incorrect_answers: ["B","C","D"])
        let q2 = TriviaQuestion(type: "boolean", difficulty: "medium", category: "General", question: "How is it?", correct_answer: "True", incorrect_answers: [])

        let mock = MockClient(questions: [q1, q2])
        let vm = await MainActor.run { TriviaListViewModel(apiClient: mock) }

        await vm.loadQuestions()

        let count = await MainActor.run { vm.questions.count }
        XCTAssertEqual(count, 2)

        await MainActor.run { vm.searchText = "how" }

        let filtered = await MainActor.run { vm.filteredQuestions }
        let firstQuestionText = await MainActor.run { filtered.first?.question }
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(firstQuestionText, "How is it?")
    }
}
