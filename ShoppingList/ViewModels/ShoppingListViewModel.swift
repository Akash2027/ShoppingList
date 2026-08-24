import SwiftUI
import SwiftData
import Combine

enum FilterType {
    case all, pending, purchased
}

@MainActor
class ShoppingListViewModel: ObservableObject {
    @Published var items: [ShoppingItem] = []
    @Published var filter: FilterType = .all

    private var modelContext: ModelContext?

    // MARK: - Initializers

    // For app usage – context injected later via updateModelContext
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        loadItems()
    }

    // For tests – context provided immediately
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadItems()
    }

    // MARK: - Context Injection (for app)
    func updateModelContext(_ newContext: ModelContext) {
        self.modelContext = newContext
        loadItems()
    }

    // MARK: - Filtering
    var filteredItems: [ShoppingItem] {
        switch filter {
        case .all: return items
        case .pending: return items.filter { !$0.isPurchased }
        case .purchased: return items.filter { $0.isPurchased }
        }
    }

    // MARK: - Actions
    func addItem(name: String) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newItem = ShoppingItem(name: name.trimmingCharacters(in: .whitespaces))
        modelContext?.insert(newItem)
        saveContext()
        loadItems()
    }

    func togglePurchased(for item: ShoppingItem) {
        item.isPurchased.toggle()
        saveContext()
        loadItems()
    }

    func deleteItem(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { filteredItems[$0] }
        for item in itemsToDelete {
            modelContext?.delete(item)
        }
        saveContext()
        loadItems()
    }

    // MARK: - Persistence (internal for testing)
    func loadItems() {   // changed from private to internal
        guard let modelContext else { return }
        let descriptor = FetchDescriptor<ShoppingItem>(sortBy: [SortDescriptor(\.name)])
        do {
            items = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to load items: \(error)")
            items = []
        }
    }

    private func saveContext() {
        guard let modelContext else { return }
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
