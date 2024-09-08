//
//  NotionRepository.swift
//  Bug Submission Screen
//
//  Created by  Abdallah Omar on 07/09/2024.
//

import Foundation

protocol NotionRepository {
    func submitBug(bug: Bug, completion: @escaping (Result<Void, Error>) -> Void)
}

class NotionRepositoryImpl: NotionRepository {
    func submitBug(bug: Bug, completion: @escaping (Result<Void, Error>) -> Void) {
        // Notion API submission logic
        guard let notionToken = getNotionToken(), let notionDatabaseID = getNotionDatabaseID() else {
            completion(.failure(NSError(domain: "Missing Token or Database ID", code: 0, userInfo: nil)))
            return
        }

        let notionAPI = "https://api.notion.com/v1/pages"
        var request = URLRequest(url: URL(string: notionAPI)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(notionToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2022-06-28", forHTTPHeaderField: "Notion-Version")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        let formattedDate = dateFormatter.string(from: Date())

        // Prepare images as Base64 strings
        let base64Images = bug.images.compactMap { $0.jpegData(compressionQuality: 0.8)?.base64EncodedString() }

        // Create the request body
        let body: [String: Any] = [
            "parent": ["database_id": notionDatabaseID],
            "properties": [
                "Priority": ["title": [["text": ["content": bug.priority]]]],
                "Title": ["rich_text": [["text": ["content": bug.description]]]],
                "Labels": ["multi_select": bug.labels.map { ["name": $0] }],
                "Assignee": ["rich_text": [["text": ["content": bug.assignee]]]],
                "Formatted Date": ["rich_text": [["text": ["content": formattedDate]]]],
                "Images": ["rich_text": [["text": ["content": bug.imageUrls.joined(separator: "\n")]]]]

            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }

            print("Successfully submitted bug to Notion: \(responseString)")
            completion(.success(()))
        }
        task.resume()
    }

    private func getNotionToken() -> String? {
        return "secret_GNDR7z66FYXEJwtPbEqIC93LWZPn343wbqgAe1NH8bi"
    }

    private func getNotionDatabaseID() -> String? {
        return "9e72c8c01c33447684e00bfcf2fb2a06"
    }
}

 
