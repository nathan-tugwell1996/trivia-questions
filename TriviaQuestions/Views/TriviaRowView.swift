import SwiftUI

struct TriviaRowView: View {
    let question: TriviaQuestion
    let viewed: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(question.category)
                Spacer()
                Text(question.difficulty.capitalized)
            }
            .font(.caption)
            .foregroundColor(.secondary)

            Text(question.question)
                .lineLimit(2)

            HStack {
                Badge(text: question.type == "boolean" ? "True / False" : "Multiple Choice")

                if viewed {
                    Badge(text: "Viewed", color: .green)
                }
            }
        }
    }
}
