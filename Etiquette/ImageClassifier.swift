//
//  ImageClassification.swift
//  LaundryLens
//
//  Created by Oluwatumininu Oguntola on 10/25/24.
//

import SwiftUI
import Vision

class ImageClassifier: ObservableObject {
    
    private let modelLabels: Dictionary<Int, String> = [
        0: "30C",
        1: "40C",
        2: "50C",
        3: "60C",
        4: "70C",
        5: "95C",
        6: "DN_bleach",
        7: "DN_dry",
        8: "DN_dry_clean",
        9: "DN_iron",
        10: "DN_steam",
        11: "DN_tumble_dry",
        12: "DN_wash",
        13: "DN_wet_clean",
        14: "DN_wring",
        15: "bleach",
        16: "chlorine_bleach",
        17: "drip_dry",
        18: "drip_dry_in_shade",
        19: "dry_clean",
        20: "dry_clean_any_solvent",
        21: "dry_clean_any_solvent_except_trichloroethylene",
        22: "dry_clean_low_heat",
        23: "dry_clean_no_steam",
        24: "dry_clean_petrol_only",
        25: "dry_clean_reduced_moisture",
        26: "dry_clean_short_cycle",
        27: "dry_flat",
        28: "hand_wash",
        29: "iron",
        30: "iron_high",
        31: "iron_low",
        32: "iron_medium",
        33: "line_dry",
        34: "line_dry_in_shade",
        35: "machine_wash_delicate",
        36: "machine_wash_normal",
        37: "machine_wash_permanent_press",
        38: "natural_dry",
        39: "non_chlorine_bleach",
        40: "shade_dry",
        41: "steam",
        42: "tumble_dry_high",
        43: "tumble_dry_low",
        44: "tumble_dry_medium",
        45: "tumble_dry_no_heat",
        46: "tumble_dry_normal",
        47: "wet_clean",
        48: "wring"
    ]
    
    private let laundryLabels: Dictionary<String, [String]> = [
        "30C": ["Machine Wash, Cold", "Initial water temperature should not exceed 30C or 65 to 85F."],
        "40C": ["Machine Wash, Warm", "Initial water temperature should not exceed 40C or 105F."],
        "50C": ["Machine Wash, Hot", "Initial water temperature should not exceed 50C or 120F."],
        "60C": ["Machine Wash, Hot", "Initial water temperature should not exceed 60C or 140F."],
        "70C": ["Machine Wash, Hot", "Initial water temperature should not exceed 70C or 160F."],
        "95C": ["Machine Wash, Hot", "Initial water temperature should not exceed 95C or 200F."],
        "DN_bleach": ["Do Not Bleach", "No bleach product may be used. Garment is not colorfast or structurally able to withstand bleach."],
        "DN_dry": ["Do Not Dry", "A machine dryer may not be used. Usually accompanied by an alternate drying method."],
        "DN_dry_clean": ["Do Not Dryclean", "Garment may not be commercially drycleaned."],
        "DN_iron": ["Do Not Iron", "Item may not be smoothed or finished with an iron."],
        "DN_steam": ["Do Not Steam", "Steam ironing will harm garment; regular dry ironing at indicated setting is acceptable."],
        "DN_tumble_dry": ["Do Not Tumble Dry", "A machine dryer may not be used. Alternative drying method suggested."],
        "DN_wash": ["Do Not Wash", "Garment may not be safely laundered by any process. Normally accompanied by Dry Clean instructions."],
        "DN_wet_clean": ["Do Not Wet Clean","Do not clean by any means of water."],
        "DN_wring": ["Do Not Wring", "Do not wring garment."],
        "bleach": ["Bleach When Needed", "Any commercially available bleach product may be used."],
        "chlorine_bleach": ["Non-Chlorine Bleach When Needed", "Only a non-chlorine, color-safe bleach may be used. Chlorine bleach may not be used."],
        "drip_dry": ["Drip Dry", "Hang dripping wet garment from line or bar without hand shaping or smoothing."],
        "drip_dry_in_shade": ["Drip Dry in Shade", "Hang dripping wet garment from line or bar without hand shaping or smoothing in shade."],
        "dry_clean": ["Dry Clean Only", "Dry Clean, any solvent, any cycle any moisture, any heat."],
        "dry_clean_any_solvent": ["Dryclean, Any Solvent", "Dry Clean, any solvent. Usually used with other restrictions on proper dry cleaning procedure."],
        "dry_clean_any_solvent_except_trichloroethylene": ["Dryclean, Any Solvent Except Trichloroethylene", "Any solvent other than trichloroethylene may be used."],
        "dry_clean_low_heat": ["Dryclean, Low Heat", "Dry Clean at Low Heat setting."],
        "dry_clean_no_steam": ["Dryclean, No Steam", "Dry Clean without steam settings."],
        "dry_clean_petrol_only": ["Dryclean, Petroleum Solvent Only", "Dry Clean with petroleum solvent only."],
        "dry_clean_reduced_moisture": ["Dryclean, Reduced Moisture", "Dry Clean with reduced moisture settings."],
        "dry_clean_short_cycle": ["Dryclean, Short Cycle", "Use Short Cycle with solvent restrictions if applicable."],
        "dry_flat": ["Dry Flat", "Lay out garment horizontally for drying."],
        "hand_wash": ["Hand Wash", "Garment may be laundered with water, detergent, or soap by gentle hand manipulation."],
        "iron": ["Iron, Any Temperature, Steam or Dry", "Ironing may be performed at any temperature with or without steam."],
        "iron_high": ["Iron, High", "Ironing, with steam or dry, at High setting (200C, 300F+)."],
        "iron_low": ["Iron, Low", "Ironing, with steam or dry, at Low setting (110C, <230F) only."],
        "iron_medium": ["Iron, Medium", "Ironing, with steam or dry, at Medium setting (150C, 230-300F)."],
        "line_dry": ["Line Dry", "Hang damp garment from line or bar, indoors or outdoors."],
        "line_dry_in_shade": ["Line Dry in Shade", "Hang damp garment from line or bar, indoors, in shade."],
        "machine_wash_normal": ["Machine Wash, Normal", "Garment may be laundered using hottest water, detergent, and machine agitation."],
        "machine_wash_permanent_press": ["Machine Wash, Permanent Press", "Use machine's Permanent Press setting with cool down or cold rinse prior to reduced spin."],
        "machine_wash_delicate": ["Machine Wash, Gentle or Delicate", "Launder on setting designed for gentle agitation or reduced time for delicate items."],
        "natural_dry": ["Natural Dry", "Accompanies other drying tags."],
        "non_chlorine_bleach":  ["Non-Chlorine Bleach When Needed", "Only a non-chlorine, color-safe bleach may be used. Chlorine bleach may not be used."],
        "shade_dry": ["Dry In Shade", "Dry garment away from direct sunlight."],
        "steam": ["Use Steam Iron", "Can be ironed with a steam iron."],
        "tumble_dry_normal": ["Tumble Dry, Normal", "Dryer may be used at hottest available setting."],
        "tumble_dry_low": ["Tumble Dry, Normal, Low Heat", "Dryer may be used at a maximum Low Heat setting."],
        "tumble_dry_medium": ["Tumble Dry, Normal, Medium Heat", "Dryer may be used at a maximum Medium Heat setting."],
        "tumble_dry_high": ["Tumble Dry, Normal, High Heat", "Dryer may be used at a High Heat setting."],
        "tumble_dry_no_heat": ["Tumble Dry, Normal, No Heat", "Dryer may be used at No Heat or Air Only setting."],
        "wet_clean": ["Wet Clean", "Item requires gentle professional wet cleaning."],
        "wring": ["Wring Out", "Wring Out Garment"]
    ]
    
    @Published private var classifier = Classifier()
    
    var imageClass: String? {
        classifier.results
    }
        
    // MARK: Intent(s)
    func detect(uiImage: UIImage) -> Classification {
        guard let ciImage = CIImage (image: uiImage) else { return Classification()}
        let boxes = classifier.detect(ciImage: ciImage)
        
        let renderer = UIGraphicsImageRenderer(size: uiImage.size)
        
        var confidence: Dictionary<String, Double> = [:]
            
        let newImage = renderer.image { context in
            // Draw the original image
            uiImage.draw(in: CGRect(origin: .zero, size: uiImage.size))
            
            // Set up drawing attributes for bounding boxes
            context.cgContext.setStrokeColor(UIColor.red.cgColor)
            context.cgContext.setLineWidth(2.0)
            
            
            for box in boxes {
                let flippedBox = CGRect(x: box.rect.midX * uiImage.size.width, y: box.rect.midY * uiImage.size.height, width: box.rect.width * uiImage.size.width, height: box.rect.height * uiImage.size.height)
                print([uiImage.size.width, uiImage.size.height])
                
                confidence[getLabel(classIndex: box.classIndex)] = Double(box.score)
                context.cgContext.addRect(flippedBox)
//                context.cgContext.addRect(CG)
                context.cgContext.drawPath(using: .stroke)
            }
        }
        
        
            
        return Classification(boxedImage: newImage, classConfidences: confidence)

    }
    
    func getLabel(classIndex: Int) -> String {
        return modelLabels[classIndex] ?? "Unknown"
    }
    
    func getEnglishforLabel(classLabel: String) -> [String] {
        return laundryLabels[classLabel] ?? ["Unknown Label", "Unknown English Instructions"]
    }
        
}
