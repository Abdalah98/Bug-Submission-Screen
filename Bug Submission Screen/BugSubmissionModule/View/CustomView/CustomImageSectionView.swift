//
//  CustomImageSectionView.swift
//  Bug Submission Screen
//
//  Created by  Abdallah Omar on 08/09/2024.
//

import SwiftUI

struct ImageSectionView: View {
    @Binding var selectedImages: [UIImage]
    @State private var showImagePicker = false
    
    var body: some View {
        Section(header: Text("Images")) {
            HStack {
                if selectedImages.isEmpty {
                    Text("No Image Selected")
                        .foregroundColor(.gray)
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(selectedImages.indices, id: \.self) { index in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: selectedImages[index])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                    
                                    Button(action: {
                                        selectedImages.remove(at: index)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white)
                                            .background(Color.black.opacity(0.6))
                                            .clipShape(Circle())
                                            .padding(5)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    showImagePicker.toggle()
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .frame(width: 40, height: 40)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: { image in
                        if let image = image {
                            selectedImages.append(image)
                        }
                    })
                }
            }
        }
    }
}
