//
//  SubmitBugToNotionUseCase.swift
//  Bug Submission Screen
//
//  Created by  Abdallah Omar on 07/09/2024.
//

import Foundation
class SubmitBugToNotionUseCase {
    private let notionRepository: NotionRepository

    init(notionRepository: NotionRepository) {
        self.notionRepository = notionRepository
    }

    func execute(bug: Bug, completion: @escaping (Result<Void, Error>) -> Void) {
        notionRepository.submitBug(bug: bug, completion: completion)
    }
}
