# 🛒 Shopping List App

A simple Shopping List application built with SwiftUI and SwiftData, demonstrating professional iOS engineering practices.

---

## 📱 Features

- ✅ Add items to the list
- ✅ Mark items as purchased (toggle)
- ✅ Delete items
- ✅ Filter: All / Pending / Purchased
- ✅ Persistent storage with SwiftData
- ✅ Unit tests for all business logic

---

## 🏗️ Architecture

- **MVVM** – Model-View-ViewModel pattern
- **SwiftData** – Local persistence
- **Combine** – Reactive state management
- **Clean Code** – Single Responsibility, meaningful naming, small functions

```text

ShoppingList/
├── Models/
│ └── ShoppingItem.swift # Data model
├── ViewModels/
│ └── ShoppingListViewModel.swift # Business logic
├── Views/
│ ├── ShoppingListView.swift # Main view
│ └── AddItemView.swift # Add item sheet
├── Services/
│ └── ShoppingListStore.swift # Persistence (optional)
└── ShoppingListTests/
├── ShoppingItemTests.swift
└── ShoppingListViewModelTests.swift

```
---

## 🛠️ Engineering Practices Applied

### ✅ Git & Collaboration
- Feature branches (`feature/add-shopping-item`, `feature/toggle-purchased`, etc.)
- Meaningful commits with conventional commit messages
- Pull request simulation and code review

### ✅ Debugging
- Breakpoints in `filteredItems`, `addItem`, `togglePurchased`, `deleteItem`
- LLDB commands: `po`, `expr`, `bt`
- View Debugger for inspecting UI hierarchy
- Instruments: Allocations & Leaks (no leaks detected)

### ✅ Unit Testing (XCTest)
- `ShoppingItemTests` – model validation
- `ShoppingListViewModelTests` – business logic tests:
  - Adding items with validation
  - Toggling purchase state
  - Deleting items
  - Filtering (All, Pending, Purchased)
  - Loading from SwiftData
- All tests passing: **12+ test cases** ✅

### ✅ Code Quality (SwiftLint)
- Integrated SwiftLint as a build phase
- Fixed all warnings (trailing whitespace, trailing comma, closure syntax)
- Custom `.swiftlint.yml` configuration
- **0 violations** ✅

### ✅ Code Review
- Reviewed `ShoppingListViewModel.swift` with a checklist:
  - Naming, Single Responsibility, Error Handling, Force Unwraps
- Added user‑friendly error feedback (`errorMessage`)

### ✅ Clean Code
- MVVM maintained
- Single Responsibility Principle applied
- Small, focused functions
- Meaningful variable and function names
- Proper error handling

### ✅ Memory Management
- Used `[weak self]` in Combine sink to avoid retain cycles
- ARC understood and applied correctly
- No memory leaks detected in Instruments

---

## 🧪 Running Tests

### In Xcode:
Product → Test (⌘U)

### In Terminal:
```bash
xcodebuild test -scheme ShoppingList -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
