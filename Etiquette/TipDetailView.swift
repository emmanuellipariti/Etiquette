//
//  TipDetailView.swift
//  Label
//
//  Created by Emmanuel Lipariti on 09/12/24.
//
// TipDetailView for each stain type

import SwiftUICore
import SwiftUI
struct TipDetailView: View {
    var tipName: String
    
    // Data for each stain type
    let remedies: [String: [(fabric: String, remedy: String)]] = Data.remedies
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let stainRemedies = remedies[tipName] {
                    ForEach(stainRemedies, id: \.fabric) { remedy in
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(UIColor { traitCollection in
                                    // Usa un colore personalizzato per garantire la visibilità
                                    traitCollection.userInterfaceStyle == .dark ? UIColor(white: 0.2, alpha: 1.0) : UIColor(white: 0.95, alpha: 1.0)
                                }))
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Ombra per la card
                            
                            VStack(alignment: .leading, spacing: 12) {
                                // Titolo del tessuto
                                Text(remedy.fabric)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(UIColor.label)) // Colore dinamico per il testo
                                    .lineLimit(1) // Evita il ritorno a capo nel titolo
                                    .padding(.bottom, 8) // Padding inferiore per distanziare dalla descrizione
                                    .accessibilityLabel("Fabric: \(remedy.fabric)") // Etichetta per lettori di schermo
                                
                                // Descrizione del rimedio
                                Text(remedy.remedy)
                                    .font(.body)
                                    .foregroundColor(Color(UIColor.label)) // Colore dinamico per il testo
                                    .lineSpacing(6) // Spaziatura tra le righe
                                    .fixedSize(horizontal: false, vertical: true) // Permette il testo multilinea
                                    .lineLimit(nil) // Consente il ritorno a capo
                                    .padding(.top, 8) // Padding superiore per distanziare dal titolo
                                    .accessibilityLabel("Remedy: \(remedy.remedy)") // Etichetta per lettori di schermo
                                    .accessibilityAddTraits(.isStaticText) // Contrassegna come testo statico
                            }
                            .padding([.horizontal, .top, .bottom]) // Padding uniforme attorno alla card
                            .frame(maxWidth: .infinity, alignment: .leading) // Allinea il contenuto a sinistra
                        }
                        .padding(.horizontal) // Padding esterno per la card
                        .accessibilityElement(children: .combine) // Combina i contenuti della card in un'unica entità
                        .accessibilityLabel("Tap to view remedy for \(remedy.fabric). Remedy: \(remedy.remedy)") // Aggiungi una descrizione di cosa fa l'interazione
                        .accessibilityAction(named: "Show Remedy Details") {
                            // Aggiungi azione personalizzata per la selezione della card
                            print("Card for \(remedy.fabric) tapped")
                            // Qui si può aggiungere logica per navigare o fare altre azioni
                        }
                    }
                } else {
                    // Messaggio di fallback nel caso non ci siano rimedi
                    Text("No remedies available for this stain type.")
                        .foregroundColor(Color(UIColor.secondaryLabel)) // Colore grigio per il testo di fallback
                        .padding()
                        .accessibilityLabel("No remedies found for \(tipName). Please check back later for more information.") // Etichetta per lettori di schermo
                }
            }
            .padding(.vertical, 20) // Padding verticale per l'intera lista
        }
        .background(Color(UIColor.systemGroupedBackground)) // Sfondo dinamico per l'intera schermata
        .navigationBarTitle(tipName, displayMode: .inline) // Titolo nella barra di navigazione
        .accessibilityLabel("Detail view for \(tipName) stain. Includes remedies for various fabrics.") // Etichetta generale per la vista
        .accessibilityElement(children: .combine) // Unisce gli elementi figli per una migliore esperienza con lettori di schermo
    }
}















