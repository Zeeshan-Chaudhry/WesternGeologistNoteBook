//
//  Western_Geologist_NoteBookApp.swift
//  Western_Geologist_NoteBook
//
//  Created by Zeeshan Chaudhry on 2024-11-08.
//

import SwiftUI

@main
struct Western_Geologist_NotebookApp: App {
    init() {
        // Customize the navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 1.0, green: 0.65, blue: 0.0, alpha: 1.0) // Orangey-yellow color
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = .white // White button color
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
