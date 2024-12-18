//
//  MyItemsView.swift
//  Label
//
//  Created by Emmanuel Lipariti on 10/12/24.
//

import SwiftUI

struct MyItemsView: View {
    @State private var isFilterPanelVisible: Bool = false // Stato per il pannello dei filtri
    @State private var selectedCategories: Set<String> = [] // Categorie selezionate
    @State private var searchText: String = "" // Testo della barra di ricerca
    @State private var isEditViewPresented: Bool = false // Stato per presentare EditView
    
    // Tutte le categorie disponibili
    private let categories = ["Layers", "Shirts", "Sweaters", "Pants", "Suits", "Dresses", "Skirts", "Shoes", "Accessories", "Home"]

    var body: some View {
        NavigationView {
            VStack {
                // Barra di ricerca con pulsante filtri
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search your item", text: $searchText)
                            .foregroundColor(.primary) // Si adatta al colore del testo principale
                            .disableAutocorrection(true)
                            .accessibilityLabel("Search for an item") // Etichetta di ricerca
                            .accessibilityHint("Enter keywords to search for items.")
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6)) // Colore che cambia automaticamente tra modalità chiara e scura
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)

                    // Pulsante per i filtri
                    Button(action: {
                        withAnimation {
                            isFilterPanelVisible.toggle() // Mostra/Nascondi il pannello dei filtri
                        }
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.blue) // Colore blu, cambia per le modalità
                    }
                    .padding(.leading, 10) // Spaziatura verso sinistra
                    .accessibilityLabel("Open Filters") // Aggiungi l'etichetta per il pulsante dei filtri
                    .accessibilityHint("Tap to show or hide filter options.") // Fornisce un suggerimento all'utente
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // Filtro categorie
                if isFilterPanelVisible {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    toggleCategorySelection(category)
                                }) {
                                    Text(category)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedCategories.contains(category) ? Color.blue : Color.gray.opacity(0.3))
                                        .foregroundColor(selectedCategories.contains(category) ? .white : .primary) // Colore che cambia dinamicamente
                                        .cornerRadius(12)
                                        .accessibilityLabel("Category: \(category)") // Etichetta per VoiceOver
                                        .accessibilityHint("Tap to select or deselect this category.") // Descrizione dell'azione
                                        
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                }

                // Pulsante "Add Item" posizionato in alto
                HStack {
                    AddItemButton(isEditViewPresented: $isEditViewPresented) // Passaggio del binding qui
                        .frame(width: UIScreen.main.bounds.width / 2 - 20) // Larghezza metà dello schermo
                        .padding(.leading)
                    Spacer() // Per centrare a sinistra
                }
                .padding(.top, 20)

                Spacer() // Per gestire il layout
            }
            .navigationTitle("My Items")
            .background(Color(UIColor.systemGroupedBackground)) // Colore di sfondo che si adatta automaticamente
            .sheet(isPresented: $isEditViewPresented) { // Presenta EditView
                EditView(
                    classConfidence: [:],
                    showEditView: $isEditViewPresented,
                    showMyItemsView: .constant(false), // O il binding appropriato per tornare
                    classifier: ImageClassifier()
                )
            }
        }
    }
    
    private func toggleCategorySelection(_ category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}

// MARK: - Add Item Button
struct AddItemButton: View {
    @Binding var isEditViewPresented: Bool // Binding della variabile di stato
    
    var body: some View {
        Button(action: {
            // Presenta EditView quando il pulsante viene premuto
            isEditViewPresented = true
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.2))
                    .shadow(color: Color.blue.opacity(0.3), radius: 6, x: 0, y: 3)

                VStack {
                    Circle()
                        .fill(Color.blue.opacity(0.5))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.white)
                        )
                    Text("Add Item")
                        .font(.headline)
                        .foregroundColor(.blue) // Colore del testo che si adatta alla modalità
                }
            }
            .frame(height: 160) // Altezza della card
        }
        .accessibilityLabel("Add Item") // Etichetta per VoiceOver
        .accessibilityHint("Tap to add a new item to your collection.") // Suggerimento per VoiceOver
    }
}

// MARK: - Preview
struct MyItemsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MyItemsView()
                .preferredColorScheme(.light) // Modalità chiara per il preview
            MyItemsView()
                .preferredColorScheme(.dark) // Modalità scura per il preview
        }
    }
}

