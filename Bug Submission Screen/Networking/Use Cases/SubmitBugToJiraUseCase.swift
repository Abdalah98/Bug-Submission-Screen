//
//  SubmitBugToJiraUseCase.swift
//  Bug Submission Screen
//
//  Created by  Abdallah Omar on 07/09/2024.
//

import Foundation
class SubmitBugToJiraUseCase {
    private let jiraRepository: JiraRepository

    init(jiraRepository: JiraRepository) {
        self.jiraRepository = jiraRepository
    }

    func execute(bug: Bug, completion: @escaping (Result<Void, Error>) -> Void) {
        jiraRepository.submitBug(bug: bug, completion: completion)
    }
}
