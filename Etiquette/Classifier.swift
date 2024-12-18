//
//  Classifier.swift
//  LaundryLens
//
//  Created by Oluwatumininu Oguntola on 10/25/24.
//

import CoreML
import Vision
import CoreImage

struct Classifier {
    
    
    
    private(set) var results: String = ""
    
    
    mutating func detect(ciImage: CIImage) -> [BoundingBox] {
        
        guard let model = try? VNCoreMLModel(for: LabelRecognizer(configuration: MLModelConfiguration()).model)
        else {
            print("Early Return: Couldn't load model")
            return [BoundingBox]()
        }
        
        let request = VNCoreMLRequest(model: model)
        request.imageCropAndScaleOption = .scaleFill
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Error performing request: \(error)")
        }

        let observations = request.results![0] as! VNCoreMLFeatureValueObservation
        let detections = observations.featureValue.multiArrayValue
        
        let shape = detections!.shape
        guard shape.count == 3, shape[0] == 1, shape[1] == 53, shape[2] == 8400 else {
            fatalError("Unexpected shape: \(shape)")
        }

        var identifications: [BoundingBox] = []


        for i in 0..<8400 {
            let x_coord = (detections?[[NSNumber(value: 0), NSNumber(value: 0), NSNumber(value: i)]].doubleValue)!
            let y_coord = (detections?[[NSNumber(value: 0), NSNumber(value: 1), NSNumber(value: i)]].doubleValue)!
            let box_width = (detections?[[NSNumber(value: 0), NSNumber(value: 2), NSNumber(value: i)]].doubleValue)!
            let box_height = (detections?[[NSNumber(value: 0), NSNumber(value: 3), NSNumber(value: i)]].doubleValue)!
            
           
            
            let coord_rect:CGRect = CGRect(x: x_coord - box_width, y: y_coord - box_height, width: box_width, height: box_height)
            
            
            let t: CGAffineTransform = CGAffineTransformMakeScale(1.0 / 640, 1.0 / 640);
            let rect: CGRect = CGRectApplyAffineTransform(coord_rect, t);
            
            
            var max_score = 0.0
            var class_index = -1
            
            for j in 4..<53 {
                let accessIndex = [NSNumber(value: 0), NSNumber(value: j), NSNumber(value: i)]
                
                let class_score = Double((detections?[accessIndex].floatValue)!)
                
                if (class_score > max_score) {
                    max_score = class_score
                    class_index = j - 4
                }
            }
            
            if class_index >= 0 {
                let new_box = BoundingBox(classIndex: class_index, score: Float(max_score), rect: rect)
//                print(String(describing: new_box))
                identifications.append(new_box)
            }
            
            
        }
        
        let valid_box_indices = nonMaxSuppressionMultiClass(numClasses: 49, boundingBoxes: (identifications), scoreThreshold: 0.5, iouThreshold: 0.5, maxPerClass: 1, maxTotal: 5)
        
        var boundingBoxes = [BoundingBox]()
        
        for i in valid_box_indices {
            let box = identifications[i]
            boundingBoxes.append(box)
        }
    
        
//        print("Width: \(String(describing: ciImage.extent.width))")
//        print("Height: \(String(describing: ciImage.extent.height))")
        
    
        
        return boundingBoxes
        
    }
    
}
