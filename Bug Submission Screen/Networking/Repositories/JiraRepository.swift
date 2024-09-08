//
//  JiraRepository.swift
//  Bug Submission Screen
//
//  Created by  Abdallah Omar on 07/09/2024.
//

import Foundation
protocol JiraRepository {
    func submitBug(bug: Bug, completion: @escaping (Result<Void, Error>) -> Void)
}

class JiraRepositoryImpl: JiraRepository {
    func submitBug(bug: Bug, completion: @escaping (Result<Void, Error>) -> Void) {
        // Jira API submission logic
        let jiraAPIKey = "ATATT3xFfGF0s9_GG0h9Lr9xeVIUufivoCbkF8VTj1RcDp4iRQkofbWAEecEnTrXSgxRaKeqC_vIlOEvOTQS0Xqj6MVJi0aGg9Fr7rNtvit__EQCc9knLtje3hGmd8XIbrIGNBwQ43uYSUl0doYQHxaB92TleAGBlSvYoeVQOiw3yxNVzJBdcb8=9C74BB13"
        let username = "elmnassa.int44@gmail.com"
        
        let url = URL(string: "https://elmnassaint44.atlassian.net/rest/api/3/issue")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let credentials = "\(username):\(jiraAPIKey)"
        let authData = credentials.data(using: .utf8)?.base64EncodedString() ?? ""
        request.setValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "fields": [
                "project": ["key": "SCRUM"],
                "summary": bug.description,
                "issuetype": ["name": "Bug"],
                "labels": bug.labels,
                "assignee": ["name": bug.assignee]
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
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

            print("Successfully submitted bug to Jira: \(responseString)")
            completion(.success(()))
        }
        task.resume()
    }
}
