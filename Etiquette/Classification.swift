//
//  Classification.swift
//  LaundryLens
//
//  Created by Oluwatumininu Oguntola on 10/29/24.
//

import Foundation
import UIKit

public struct Classification {
    public let boxedImage: UIImage?

    public let classConfidences: Dictionary<String, Double>?

    public init(boxedImage: UIImage? = nil, classConfidences: Dictionary<String, Double>? = nil) {
        self.boxedImage = boxedImage
        self.classConfidences = classConfidences
    }
}

public struct LaundryLabel: Comparable, Identifiable {
    
    
    public static func < (lhs: LaundryLabel, rhs: LaundryLabel) -> Bool {
        return lhs.label < rhs.label
    }
    
    public static func > (lhs: LaundryLabel, rhs: LaundryLabel) -> Bool {
        return lhs.label > rhs.label
    }
    
    public let label: String
    public let confidence: Double
    public let meaning: [String]
    public let id: UUID

    public init(label: String, meaning: [String], confidence: Double = 0.0) {
        self.label = label
        self.meaning = meaning
        self.confidence = confidence
        self.id = UUID()
    }
}
