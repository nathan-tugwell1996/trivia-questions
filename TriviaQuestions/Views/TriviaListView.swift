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
                }
                .searchable(text: $viewModel.searchText)
                .task {
                    if !hasLoadedOnce {
                        hasLoadedOnce = true
                        await viewModel.loadQuestions()
                    }
                }
                .navigationDestination(for: TriviaQuestion.self) {
                    TriviaDetailView(question: $0)
                }
            }
        }
    }
