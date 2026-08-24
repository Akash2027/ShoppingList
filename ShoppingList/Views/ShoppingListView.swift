import SwiftUI
import SwiftData

// MARK: - Filter Button Component
struct FilterButton: View {
    let title: String
    let filter: FilterType
    let currentFilter: FilterType
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(currentFilter == filter ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(currentFilter == filter ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Main Shopping List View
struct ShoppingListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ShoppingListViewModel(modelContext: nil)
    @State private var showingAddSheet = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    FilterButton(title: "All", filter: .all, currentFilter: viewModel.filter) {
                        viewModel.filter = .all
                    }
                    FilterButton(title: "Pending", filter: .pending, currentFilter: viewModel.filter) {
                        viewModel.filter = .pending
                    }
                    FilterButton(title: "Purchased", filter: .purchased, currentFilter: viewModel.filter) {
                        viewModel.filter = .purchased
                    }
                }
                .padding(.horizontal)

                List {
                    ForEach(viewModel.filteredItems) { item in
                        HStack {
                            Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isPurchased ? .green : .gray)
                                .onTapGesture {
                                    viewModel.togglePurchased(for: item)
                                }
                            Text(item.name)
                                .strikethrough(item.isPurchased)
                        }
                    }
                    .onDelete { offsets in
                        viewModel.deleteItem(at: offsets)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            // swiftlint:disable:next multiple_closures_with_trailing_closure
            .sheet(isPresented: $showingAddSheet, onDismiss: nil, content: {
                AddItemView { name in
                    viewModel.addItem(name: name)
                    showingAddSheet = false
                }
            }) /// here this ) paranthesis I have added to avoid the violations using swiftlint and added content
            /// .sheet(isPresented: $showingAddSheet) {
            .onAppear {
                // Inject the real context and load data
                viewModel.updateModelContext(modelContext)
            }
        }
    }
}
