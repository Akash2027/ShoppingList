import Foundation
import SwiftData

@Model
final class ShoppingItem {
    var name: String
    var isPurchased: Bool

    init(name: String, isPurchased: Bool = false) {
        self.name = name
        self.isPurchased = isPurchased
    }
}
