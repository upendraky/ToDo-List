//
//  ContentView.swift
//  mk01
//
//  Created by Upendra Kumar Yadav on 26/05/26.
//
import SwiftUI
import Combine   // ← ADD THIS LINE

// 1. DATA MODEL - Represents one task
struct TodoItem: Identifiable {
    let id = UUID()          // Unique ID for each task
    var title: String        // Task text
    var isCompleted: Bool = false  // Done or not
}
// 2. STATE - Manages our list of tasks
class TodoViewModel: ObservableObject {
    @Published var items: [TodoItem] = [
        TodoItem(title: "Buy groceries"),
        TodoItem(title: "Read a book"),
        TodoItem(title: "Go for a walk")
    ]
    @Published var newTaskText: String = ""

    func addTask() {
        let trimmed = newTaskText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        items.append(TodoItem(title: trimmed))
        newTaskText = ""
    }

    func toggleTask(item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }

    func deleteTask(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}
// 3. UI - What the user sees
struct ContentView: View {
    @StateObject var viewModel = TodoViewModel()

    var body: some View {
        NavigationView {
            VStack {

                // ── Input Bar ──
                HStack {
                    TextField("Add a new task...", text: $viewModel.newTaskText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: viewModel.addTask) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding()

                // ── Task List ──
                List {
                    ForEach(viewModel.items) { item in
                        HStack {
                            // Checkbox icon
                            Image(systemName: item.isCompleted
                                  ? "checkmark.circle.fill"
                                  : "circle")
                                .foregroundColor(item.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    viewModel.toggleTask(item: item)
                                }

                            // Task title
                            Text(item.title)
                                .strikethrough(item.isCompleted, color: .gray)
                                .foregroundColor(item.isCompleted ? .gray : .primary)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: viewModel.deleteTask) // swipe to delete
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("My To-Do List ✅")
            .toolbar {
                EditButton() // enables reorder & delete mode
            }
        }
    }
}

// 4. PREVIEW
#Preview {
    ContentView()
}
