import SwiftUI

struct TipsView: View {
    @State private var showInfoModal = false // Stato per mostrare la modale

    let tips = ["Blood", "Red Wine", "Oil and Grease", "Grass", "Coffee and Tea", "Sweat and Deodorant", "Chocolate", "Ink"]
    let images = ["bloodImage", "wineImage", "oilImage", "grassImage", "coffeeImage", "sweatImage", "chocolateImage", "inkImage"] // Nomi delle immagini

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {  // Spazio tra i rettangoli ridotto
                    ForEach(tips.indices, id: \.self) { index in
                        NavigationLink(destination: TipDetailView(tipName: tips[index])) {
                            ZStack {
                                // Rettangolo di base
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(UIColor.secondarySystemBackground)) // Adattato alla modalità
                                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 3)
                                    .frame(height: 80) // Rettangolo più stretto

                                // Sovrapposizione contenuti
                                HStack {
                                    // Left Side: Text Content
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(tips[index])
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary) // Colore del testo dinamico
                                            .lineLimit(2)  // Permette di visualizzare più righe se necessario
                                            .minimumScaleFactor(0.5) // Rende il testo più adattabile
                                            .shadow(color: Color.white.opacity(0.8), radius: 5, x: 0, y: 0) // Ombra per rendere il testo più visibile
                                    }
                                    .padding(.leading)

                                    Spacer()

                                    // Right Side: Image with progressive gradient (Sfumatura da sinistra a destra)
                                    ZStack {
                                        if let uiImage = UIImage(named: images[index]) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 90, height: 80) // Larghezza e altezza dell'immagine regolata
                                                .clipShape(RoundedRectangle(cornerRadius: 8)) // Ridotto smusso agli angoli
                                                .overlay(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color(UIColor.secondarySystemBackground).opacity(1), .clear]),
                                                        startPoint: .leading, // La sfumatura parte dal bordo sinistro
                                                        endPoint: .trailing // Sfuma verso destra
                                                    )
                                                )
                                                .clipped()
                                        } else {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(.gray)
                                                .opacity(0.5)
                                        }
                                    }
                                    .frame(width: 90) // L'immagine si estende per una larghezza moderata
                                }
                                .padding(.vertical, 9)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 16) // Spazio in fondo
            }
            .navigationBarTitle("Stain Removal Tips", displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                showInfoModal = true
            }) {
                Image(systemName: "info.circle")
                    .font(.title2)
                    .foregroundColor(.primary) // Colore dell'icona dinamico
            })
            .sheet(isPresented: $showInfoModal) {
                InfoModalView()
                    .presentationDetents([.medium, .large]) // Supporta due altezze
                    .presentationDragIndicator(.visible) // Indicatore per la modale
            }
            .background(Color(UIColor.systemGroupedBackground)) // Background dinamico
        }
    }
}

// Vista per la Modale Informativa
struct InfoModalView: View {
    @Environment(\.presentationMode) var presentationMode // Per chiudere la modale

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("How to Use This Section")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)

                    Text("""
                    Explore our Tips section, where you'll find natural, grandma-approved remedies for removing tough stains without harming your clothes. We've organized solutions into categories based on the type of stain, so you can easily find tips tailored to your needs.

                    Each remedy includes suggestions depending on your specific fabric.

                    Tap on a category to discover the recommended treatments and choose the one that works best for you.
                    """)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.secondary) // Colore secondario dinamico
                        .padding(.horizontal)
                }
                .padding()
            }
            .navigationBarTitle("Info", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss() // Chiudi la modale
            })
        }
    }
}

// MARK: - Preview
struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TipsView()
                .preferredColorScheme(.light) // Modalità chiara per il preview
            TipsView()
                .preferredColorScheme(.dark) // Modalità scura per il preview
        }
    }
}
















