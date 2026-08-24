import XCTest
@testable import ShoppingList

final class ShoppingItemTests: XCTestCase {
    
    func testCreateShoppingItem() {
        let item = ShoppingItem(name: "Test")
        XCTAssertEqual(item.name, "Test")
        XCTAssertFalse(item.isPurchased)
    }
    
    func testMarkItemAsPurchased() {
        let item = ShoppingItem(name: "Test")
        item.isPurchased = true
        XCTAssertTrue(item.isPurchased)
    }
}
