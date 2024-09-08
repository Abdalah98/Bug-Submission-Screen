//
//  ImageUploadService.swift
//  Bug Submission Screen
//
//  Created by  Abdallah Omar on 08/09/2024.
//

import SwiftUI

class ImageUploadService {
    private let imgurClientID = "acfa593e5fd844f"
    
    /// Uploads a single image to Imgur and returns the URL
    func uploadImageToImgur(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            completion(nil)
            return
        }
        let boundary = UUID().uuidString

        var request = URLRequest(url: URL(string: "https://api.imgur.com/3/image")!)
        request.httpMethod = "POST"
        request.setValue("Client-ID \(imgurClientID)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Upload failed: \(String(describing: error))")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let data = json["data"] as? [String: Any],
               let link = data["link"] as? String {
                DispatchQueue.main.async {
                    print("Uploaded Image URL: \(link)")
                    completion(link)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }

    /// Uploads multiple images to Imgur and returns an array of URLs
    func uploadImagesToImgur(images: [UIImage], completion: @escaping ([String]?) -> Void) {
        var uploadedUrls = [String]()
        let dispatchGroup = DispatchGroup()

        for image in images {
            dispatchGroup.enter()
            uploadImageToImgur(image: image) { url in
                if let url = url {
                    uploadedUrls.append(url)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(uploadedUrls.isEmpty ? nil : uploadedUrls)
        }
    }
}
