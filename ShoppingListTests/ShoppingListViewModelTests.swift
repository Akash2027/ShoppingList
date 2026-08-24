import XCTest
import SwiftData
@testable import ShoppingList

@MainActor
final class ShoppingListViewModelTests: XCTestCase {
    
    var viewModel: ShoppingListViewModel!
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Create an in‑memory container for tests (doesn't save to disk)
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: ShoppingItem.self, configurations: config)
        modelContext = modelContainer.mainContext
        
        // Inject the context into ViewModel
        viewModel = ShoppingListViewModel(modelContext: modelContext)
    }
    
    override func tearDown() {
        viewModel = nil
        modelContext = nil
        modelContainer = nil
        super.tearDown()
    }
    
    // MARK: - Test Adding Items
    
    func testAddItem() {
        // Arrange
        let itemName = "Milk"
        
        // Act
        viewModel.addItem(name: itemName)
        
        // Assert
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.items.first?.name, itemName)
        XCTAssertFalse(viewModel.items.first?.isPurchased ?? true)
    }
    
    func testAddEmptyItemIgnored() {
        // Arrange
        let emptyName = "   "
        
        // Act
        viewModel.addItem(name: emptyName)
        
        // Assert
        XCTAssertEqual(viewModel.items.count, 0)
    }
    
    // MARK: - Test Toggle Purchased
    
    func testTogglePurchased() {
        // Arrange
        viewModel.addItem(name: "Bread")
        guard let item = viewModel.items.first else {
            XCTFail("Item not created")
            return
        }
        
        // Act
        viewModel.togglePurchased(for: item)
        
        // Assert
        XCTAssertTrue(viewModel.items.first?.isPurchased ?? false)
    }
    
    // MARK: - Test Delete
    
    func testDeleteItem() {
        // Arrange
        viewModel.addItem(name: "Eggs")
        viewModel.addItem(name: "Butter")
        XCTAssertEqual(viewModel.items.count, 2)
        
        // Act – delete the first item
        viewModel.deleteItem(at: IndexSet(integer: 0))
        
        // Assert
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.items.first?.name, "Eggs")
    }
    
    // MARK: - Test Filtering
    
    func testFilterAll() {
        // Arrange
        viewModel.addItem(name: "A")
        viewModel.addItem(name: "B")
        viewModel.addItem(name: "C")
        
        // Act – mark A and C as purchased
        viewModel.togglePurchased(for: viewModel.items[0])
        viewModel.togglePurchased(for: viewModel.items[2])
        viewModel.filter = .all
        
        // Assert – all items shown
        XCTAssertEqual(viewModel.filteredItems.count, 3)
    }
    
    func testFilterPending() {
        // Arrange
        viewModel.addItem(name: "A")
        viewModel.addItem(name: "B")
        viewModel.addItem(name: "C")
        viewModel.togglePurchased(for: viewModel.items[0])
        viewModel.togglePurchased(for: viewModel.items[2])
        
        // Act
        viewModel.filter = .pending
        
        // Assert – only pending item is B
        XCTAssertEqual(viewModel.filteredItems.count, 1)
        XCTAssertEqual(viewModel.filteredItems.first?.name, "B")
    }
    
    func testFilterPurchased() {
        // Arrange
        viewModel.addItem(name: "A")
        viewModel.addItem(name: "B")
        viewModel.addItem(name: "C")
        viewModel.togglePurchased(for: viewModel.items[0])
        viewModel.togglePurchased(for: viewModel.items[2])
        
        // Act
        viewModel.filter = .purchased
        
        // Assert – purchased items are A and C
        XCTAssertEqual(viewModel.filteredItems.count, 2)
        let names = viewModel.filteredItems.map { $0.name }.sorted()
        XCTAssertEqual(names, ["A", "C"])
    }
    
    // MARK: - Test Persistence (Loading from context)
    
    func testLoadItems() {
        // Arrange – insert an item directly into the context
        let directItem = ShoppingItem(name: "Direct")
        modelContext.insert(directItem)
        try? modelContext.save()
        
        // Act – reload items
        viewModel.loadItems()
        
        // Assert
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.items.first?.name, "Direct")
    }
}
