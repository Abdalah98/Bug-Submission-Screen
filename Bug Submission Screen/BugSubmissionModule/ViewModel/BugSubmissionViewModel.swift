//
//  BugSubmissionViewModel.swift
//  Bug Submission Screen
//
//  Created by  Abdallah Omar on 03/09/2024.
//

import Combine
import SwiftUI
 
class BugSubmissionViewModel: ObservableObject {
    //MARK: - Properties
        @Published var bug: Bug
        @Published var selectedImages: [UIImage] = []
        @Published var selectedPriority: String
        @Published var selectedLabel: String?
        @Published var selectedAssignee: String?
        @Published var isLoading: Bool = false
        
        private let submitBugToNotionUseCase: SubmitBugToNotionUseCase
        private let submitBugToJiraUseCase: SubmitBugToJiraUseCase
        
        let priorities = ["Highest", "High", "Medium", "Low"]
        let labels = ["POC", "Update", "Dev", "Production", "Sprint", "TestFlight"]
        let assignees = ["Alice", "Bob", "Charlie", "David"]

        init(
            submitBugToNotionUseCase: SubmitBugToNotionUseCase,
            submitBugToJiraUseCase: SubmitBugToJiraUseCase
        ) {
            self.submitBugToNotionUseCase = submitBugToNotionUseCase
            self.submitBugToJiraUseCase = submitBugToJiraUseCase
            let defaultPriority = ""
            self.selectedPriority = defaultPriority
            self.selectedLabel = nil
            self.selectedAssignee = nil
            self.bug = Bug(description: "", priority: defaultPriority,images: [], labels: [], assignee: "")
        }
        
        // Updates the bug data from the UI
        func updateBug() {
            bug.priority = selectedPriority
            bug.images = selectedImages
            bug.labels = selectedLabel.map { [$0] } ?? []
            bug.assignee = selectedAssignee ?? ""
        }
    
    // Method to clear all fields

    func clearAll() {
            selectedPriority = ""
            selectedLabel = nil
            selectedAssignee = nil
            selectedImages.removeAll()
            bug.description = ""
        }
    
    // Method to submit bug
        func submitBug(selectedToJira: Bool, selectedToNotion: Bool) {
            self.isLoading = true
            DispatchQueue.global(qos: .userInitiated).async {
                // Simulate network delay
                sleep(2)
                DispatchQueue.main.async {
                    if selectedToJira {
                        self.submitBugToJira()
                    }
                    if selectedToNotion {
                        self.submitBugToNotion()
                    }
                    self.isLoading = false
                }
            }
        }
    
    //MARK: - Private Func
        // Submit the bug to Notion
        private func submitBugToNotion() {
            isLoading = true  // Start loading
            submitBugToNotionUseCase.execute(bug: bug) { result in
                DispatchQueue.main.async {
                    self.isLoading = false  // Stop loading
                    switch result {
                    case .success:
                        print("Successfully submitted bug to Notion")
                        self.clearAll()
                    case .failure(let error):
                        print("Failed to submit bug to Notion: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        // Submit the bug to Jira
        private  func submitBugToJira() {
            isLoading = true  // Start loading
            submitBugToJiraUseCase.execute(bug: bug) { result in
                DispatchQueue.main.async {
                    self.isLoading = false  // Stop loading
                    switch result {
                    case .success:
                        print("Successfully submitted bug to Jira")
                        self.clearAll()
                    case .failure(let error):
                        print("Failed to submit bug to Jira: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
