//
//  TodoApplicationApp.swift
//  TodoApplication
//
//  Created by Mohamed Shafai on 13/05/2025.
//

import SwiftUI

@main
struct TodoApplicationApp: App {
    
    let provider = CoreDataProvider()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ContentView()
                    .environment(\.managedObjectContext, provider.viewContext)
            }
        }
    }
}
