//
//  Bug_Submission_ScreenApp.swift
//  Bug Submission Screen
//
//  Created by  Abdallah Omar on 03/09/2024.
//

import SwiftUI

@main
struct Bug_Submission_ScreenApp: App {
    var body: some Scene {
        WindowGroup {
            let notionRepository = NotionRepositoryImpl()
            let jiraRepository = JiraRepositoryImpl()
            
            let submitBugToNotionUseCase = SubmitBugToNotionUseCase(notionRepository: notionRepository)
            let submitBugToJiraUseCase = SubmitBugToJiraUseCase(jiraRepository: jiraRepository)
            
            let viewModel = BugSubmissionViewModel(
                submitBugToNotionUseCase: submitBugToNotionUseCase,
                submitBugToJiraUseCase: submitBugToJiraUseCase
            )
            
            BugSubmissionView(viewModel: viewModel)
        }
    }
}

