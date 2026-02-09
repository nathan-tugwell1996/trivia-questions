import SwiftUI

struct TriviaDetailView: View {
    let question: TriviaQuestion

    @State private var answers: [String] = []
    @State private var selectedAnswer: String? = nil
    @State private var showResultAlert = false
    @State private var isCorrect = false
    @State private var answered = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                Badge(text: question.type.uppercased())

                Text(question.question)
                    .font(.title2)

                Text("Choose an answer")
                    .font(.headline)
                    .padding(.top)

                VStack(spacing: 10) {
                    ForEach(answers, id: \.self) { answer in
                        Button(action: {
                            guard !answered else { return }
                            selectedAnswer = answer
                            isCorrect = (answer == question.correct_answer)
                            answered = true
                            showResultAlert = true
                            ViewedQuestionsStore.shared.markViewed(question.id)
                        }) {
                            HStack {
                                Text(answer)
                                    .foregroundColor(textColor(for: answer))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if answered {
                                    if answer == question.correct_answer {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    } else if answer == selectedAnswer {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 8).strokeBorder(borderColor(for: answer), lineWidth: 1))
                        }
                        .disabled(answered)
                    }
                }

                if answered {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Correct Answer")
                            .bold()
                        Text(question.correct_answer)
                            .foregroundColor(.green)

                        Text("Incorrect Answers")
                            .bold()

                        ForEach(question.incorrect_answers, id: \.self) { ans in
                            Text(ans)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.top)
                }

            }
            .padding()
        }
        .onAppear {
            if answers.isEmpty {
                answers = ([question.correct_answer] + question.incorrect_answers).shuffled()
            }
            ViewedQuestionsStore.shared.markViewed(question.id)
        }
        .alert(isPresented: $showResultAlert) {
            Alert(
                title: Text(isCorrect ? "Correct!" : "Incorrect"),
                message: Text(isCorrect ? "Nice — that's the right answer." : "Sorry — the correct answer is:\n\(question.correct_answer)"),
                dismissButton: .default(Text("OK")) {
                }
            )
        }
    }

    private func textColor(for answer: String) -> Color {
        guard answered else { return .primary }
        if answer == question.correct_answer { return .green }
        if answer == selectedAnswer { return .red }
        return .primary
    }

    private func borderColor(for answer: String) -> Color {
        guard answered else { return .secondary }
        if answer == question.correct_answer { return .green }
        if answer == selectedAnswer { return .red }
        return .secondary
    }
}
