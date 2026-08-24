import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @State private var itemName = ""
    let onAdd: (String) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Item Name", text: $itemName)
                    .textInputAutocapitalization(.words)
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(itemName)
                    }
                    .disabled(itemName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
