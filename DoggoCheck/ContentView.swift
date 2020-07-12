//
//  ContentView.swift
//  DoggoCheck
//
//  Created by Julien Segers on 12/07/2020.
//  Copyright © 2020 Julien Segers. All rights reserved.
//

import SwiftUI
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage


struct ContentView: View {
    
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?
    
    @State var dogBreed: String = ""

    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 215/255, green: 249/255, blue: 255/255)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 100) {
                    Image("background-image-1")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .shadow(radius: 1)
                    Text(dogBreed)
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(Color(red: 59/255, green: 105/255, blue: 120/255))
                    Button(action: {
                        self.showSheet = true
                    }) {
                        HStack {
                            Image(systemName: "camera")
                                .font(.headline)
                                .padding([.vertical, .leading])
                            Text("Choose a picture")
                                .fontWeight(.bold)
                                .font(.headline)
                                .padding([.trailing])
                        }
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 134/255, green: 168/255, blue: 231/255), Color(red: 145/255, green: 234/255, blue: 228/255)]), startPoint: .bottom, endPoint: .top))
                        .cornerRadius(20)
                        .shadow(radius: 2)
                    }
                    .actionSheet(isPresented: $showSheet) {
                        ActionSheet(title: Text("Select a photo"), message: nil, buttons: [
                            .default(Text("Camera"), action: {
                                self.showImagePicker = true
                                self.sourceType = .camera
                            }),
                            .default(Text("Photo Library"), action: {
                                self.showImagePicker = true
                                self.sourceType = .photoLibrary
                            }),
                            .cancel()
                        ])
                    }
                }
            }
        }.sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$image, dogBreed: self.$dogBreed, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
