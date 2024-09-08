//
//  UIImage+Extension.swift
//  Bug Submission Screen
//
//  Created by  Abdallah Omar on 07/09/2024.
//

import Foundation
import SwiftUI
func convertImageToBase64(_ image: UIImage) -> String? {
    if let imageData = image.jpegData(compressionQuality: 0.8) {
        return imageData.base64EncodedString()
    }
    return nil
}
