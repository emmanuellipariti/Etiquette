//
//  LabelApp.swift
//  Label
//
//  Created by Emmanuel Lipariti on 09/12/24.
//

import SwiftUI

@main
struct Etiquette: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                // Tab per "My Items"
                MyItemsView()
                    .tabItem {
                        Image(systemName: "tag") // Icona di una lista
                        Text("My Items") // Titolo della scheda
                    }
                
                // Tab per "Tips"
                TipsView()
                    .tabItem {
                        Image(systemName: "lightbulb") // Icona di una lampadina
                        Text("Tips") // Titolo della scheda
                    }
                
            }
        }
    }
}

