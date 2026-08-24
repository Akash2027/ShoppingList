import SwiftUI
import SwiftData

@main
struct ShoppingListApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ShoppingItem.self
            /// here , was there using the swiftlint I removed it
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ShoppingListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
