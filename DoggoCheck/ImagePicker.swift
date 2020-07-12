//
//  ImagePicker.swift
//  DoggoCheck
//
//  Created by Julien Segers on 12/07/2020.
//  Copyright © 2020 Julien Segers. All rights reserved.
//

import Foundation
import SwiftUI
import CoreML
import SDWebImage
import Vision


class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage?
    @Binding var dogBreed: String
    @Binding var isShown: Bool
    
    
    
    var contentView = ContentView()
    
    init(image: Binding<UIImage?>, dogBreed: Binding<String>, isShown: Binding<Bool>) {
        _image = image
        _dogBreed = dogBreed
        _isShown = isShown
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            guard let convertedImage = CIImage(image: userPickedImage) else {
                fatalError("Cannot convert to CIImage.")
            }
            isShown = false
            detect(image: convertedImage)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: DoggoData().model) else {
            fatalError("Cannot import model.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not classify image.")
            }
            
            self.dogBreed = classification.identifier.capitalized
            
            
            
            
            //            self.navigationItem.title = classification.identifier.capitalized
            //
            //            self.requestInfo(flowerName: classification.identifier)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}



struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    
    @Binding var image: UIImage?
    @Binding var dogBreed: String
    @Binding var isShown: Bool
    
    
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image, dogBreed: $dogBreed, isShown: $isShown)
    }
    
    
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
