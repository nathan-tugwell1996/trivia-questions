import SwiftUI

struct TriviaListView: View {
    @StateObject private var viewModel =
        TriviaListViewModel(apiClient: ApiClient())
    @StateObject private var viewedStore = ViewedQuestionsStore.shared
    @State private var hasLoadedOnce = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Group {
                    if viewModel.isLoading {
                        ProgressView("Loading questions…")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 12) {
                            Text(error)
                                .multilineTextAlignment(.center)
                            Button("Retry") {
                                Task { await viewModel.loadQuestions() }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.filteredQuestions.isEmpty {
                        VStack(spacing: 12) {
                            Text("No questions available")
                            Button("Reload") {
                                Task { await viewModel.loadQuestions() }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List(viewModel.filteredQuestions) { question in
                            NavigationLink(value: question) {
                                TriviaRowView(
                                    question: question,
                                    viewed: viewedStore.hasViewed(question.id)
                                )
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
                .navigationTitle("Trivia Quest")
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Trivia Quest")
                                .font(.headline)
                            Text("\(viewModel.questions.count) questions")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .searchable(text: $viewModel.searchText)
                .task {
                    // Load only once — don't refresh when returning from details
                    if !hasLoadedOnce {
                        hasLoadedOnce = true
                        await viewModel.loadQuestions()
                    }
                }
                .navigationDestination(for: TriviaQuestion.self) {
                    TriviaDetailView(question: $0)
                }

                if let debug = viewModel.debugMessage {
                    Text(debug)
                        .font(.caption)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                        .padding()
                }
            }
        }
    }
}
