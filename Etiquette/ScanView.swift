import SwiftUI
import UIKit

struct EditView: View {
    var classConfidence: Dictionary<String, LaundryLabel>
    @Binding var showEditView: Bool
    @Binding var showMyItemsView: Bool
    @State private var name: String = ""
    @State private var color: String = ""
    @State private var category: String = "Layers"
    @State private var labelImage: UIImage? // Foto dell'etichetta
    @State private var imagePickerIsPresenting: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showingActionSheet: Bool = false
    @State private var classifications: Dictionary<String, LaundryLabel> = [:]
    @State private var fabrics: [String] = []
    @State private var percentages: [Int] = []
    @ObservedObject var classifier: ImageClassifier

    let categories = ["Layers", "Shirts", "Sweaters", "Pants", "Suits", "Dresses", "Skirts", "Shoes", "Accessories", "Home"]

    var body: some View {
        NavigationStack {
            Form {
                // Sezione 1: Scan Label Care (per scansionare l'etichetta)
                Section(header: Text("Scan Label Care")) {
                    if labelImage != nil {
                        // Se è stata selezionata l'immagine dell'etichetta, mostriamo i risultati
                        WashingCareResultsSection(classifications: classifications)
                    } else {
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.blue, lineWidth: 1)
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
                                    .frame(width: 140, height: 100)
                                    .overlay(
                                        Group {
                                            if let image = labelImage {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 140, height: 100)
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                            } else {
                                                VStack {
                                                    Image(systemName: "tag.slash")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 30, height: 30)
                                                        .foregroundColor(.gray)
                                                    Text("No label care selected")
                                                        .foregroundColor(.gray)
                                                        .font(.caption)
                                                }
                                            }
                                        }
                                    )
                            }
                            .onTapGesture {
                                showingActionSheet = true
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                }

                // Sezione per i dettagli dell'oggetto
                Section(header: Text("Item Details")) {
                    TextField("Name", text: $name)
                        .padding(.vertical, 4)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()

                    TextField("Color", text: $color)
                        .padding(.vertical, 4)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                }

                // Sezione per la categoria
                Section(header: Text("Category")) {
                    Menu {
                        ForEach(categories, id: \.self) { categoryOption in
                            Button(action: {
                                category = categoryOption
                            }) {
                                Text(categoryOption)
                                if categoryOption == category {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(category)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }

                // Sezione Fabrics & Percentages
                Section(header: Text("Fabrics & Percentages")) {
                    ForEach(fabrics.indices, id: \.self) { index in
                        HStack {
                            TextField("Fabric", text: $fabrics[index])
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                            Spacer()
                            HStack {
                                TextField("", value: $percentages[index], formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                                    .frame(width: 60)
                                    .multilineTextAlignment(.trailing)
                                Text("%")
                            }
                        }
                    }
                    Button(action: {
                        fabrics.append("")
                        percentages.append(0)
                    }) {
                        Label("Add Fabric", systemImage: "plus.circle")
                    }
                }
            }
            .navigationTitle("Edit Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showEditView = false
                        showMyItemsView = true
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showEditView = false
                        showMyItemsView = true
                    }
                }
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Choose Photo Source"), message: Text("Select the source for your photo"), buttons: [
                    .default(Text("Take Photo")) {
                        sourceType = .camera
                        imagePickerIsPresenting = true
                    },
                    .default(Text("Choose from Library")) {
                        sourceType = .photoLibrary
                        imagePickerIsPresenting = true
                    },
                    .cancel()
                ])
            }
            .sheet(isPresented: $imagePickerIsPresenting) {
                ImagePicker(uiImage: $labelImage, isPresenting: $imagePickerIsPresenting, sourceType: $sourceType)
                    .onDisappear {
                        if let selectedImage = labelImage {
                            classify(image: selectedImage)
                        }
                    }
            }
        }
    }

    func classify(image: UIImage) {
        let resultClassification = classifier.detect(uiImage: image)
        labelImage = resultClassification.boxedImage
        let classConfidences = resultClassification.classConfidences ?? [:]
        classifications = classConfidences.reduce(into: [:]) { dict, item in
            dict[item.key] = LaundryLabel(
                label: item.key,
                meaning: classifier.getEnglishforLabel(classLabel: item.key),
                confidence: item.value
            )
        }
    }
}

// Sezione per i risultati di cura del lavaggio
struct WashingCareResultsSection: View {
    var classifications: Dictionary<String, LaundryLabel>

    var body: some View {
        ForEach(classifications.keys.sorted(), id: \.self) { classLabel in
            VStack(alignment: .leading, spacing: 8) {
                Text(classifications[classLabel]?.meaning.first ?? "Unknown")
                    .font(.headline)
                Text(classifications[classLabel]?.meaning.last ?? "No description available.")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
    }
}

// Preview
struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(
            classConfidence: [:],
            showEditView: .constant(true),
            showMyItemsView: .constant(false),
            classifier: ImageClassifier()
        )
    }
}
