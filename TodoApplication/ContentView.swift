//
//  ContentView.swift
//  TodoApplication
//
//  Created by Mohamed Shafai on 13/05/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: []) private var todoItems: FetchedResults<TodoItem>

    @State var title: String = ""
    
    private var CompletedTodoItems: [TodoItem] {
        todoItems.filter { $0.isCompleted }
    }
    
    private var PendingTodoItens: [TodoItem] {
        todoItems.filter { !$0.isCompleted }
    }
    
    var body: some View {
        
        VStack {
            TextField("add new Todo Item", text: $title)
                .textFieldStyle(.roundedBorder)
                .scaleEffect(title.isEmpty ? 1.0 : 1.05)
                .animation(.easeInOut(duration: 0.3), value: title)
                .onSubmit {
                    if !title.isEmpty {
                        let newTodo = TodoItem(context: context)
                        newTodo.title = title
                        newTodo.isCompleted = false
                        do {
                            try context.save()
                            title = ""
                        } catch {
                            print("error")
                        }
                    }
                }
            
            List {
                Section("Pending "){
                    ForEach(PendingTodoItens){ item in
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.square": "square" ).onTapGesture {
                                item.isCompleted = !item.isCompleted
                                do {
                                    try context.save()
                                } catch {
                                    print(error)
                                }
                            }
                            Text(item.title ?? "")
                        }
                    }.onDelete { indexSet in
                        for index in indexSet {
                            context.delete(CompletedTodoItems[index])
                        }
                        do {
                            try context.save()
                        } catch {
                            print(error)
                        }
                    }
                }
                Section("Completed"){
                    if CompletedTodoItems.isEmpty {
                        ContentUnavailableView("There're now completed items",systemImage: "doc")
                    } else {
                        ForEach(CompletedTodoItems){ item in
                            HStack {
                                Image(systemName: item.isCompleted ? "checkmark.square": "square" ).onTapGesture {
                                    item.isCompleted = !item.isCompleted
                                    do {
                                        try context.save()
                                    } catch {
                                        print(error)
                                    }
                                }
                                Text(item.title ?? "")
                            }
                        }.onDelete { indexSet in
                            for index in indexSet {
                                context.delete(CompletedTodoItems[index])
                            }
                            do {
                                try context.save()
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }.listStyle(.plain)
        }
        .padding()
        .navigationTitle ("Todo Application")
    }
}

#Preview {
    NavigationStack{
        ContentView()
            .environment(\.managedObjectContext , CoreDataProvider.preview.viewContext)
    }
}
