//
//  BugSubmissionView.swift
//  Bug Submission Screen
//
//  Created by  Abdallah Omar on 03/09/2024.
//

import SwiftUI
 

struct BugSubmissionView: View {
    
    @ObservedObject var viewModel: BugSubmissionViewModel
    @State private var showPopup = false
    @State private var isJiraSelected = false
    @State private var isNotionSelected = false
    
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    // Priority Section
                          Section(header: Text("Priority")) {
                              Picker("Select Priority", selection: $viewModel.selectedPriority) {
                                  ForEach(viewModel.priorities, id: \.self) { priority in
                                      Text(priority).tag(priority)
                                  }
                              }
                              .pickerStyle(SegmentedPickerStyle())
                          }
                          
                          // Labels Section
                          Section(header: Text("Labels")) {
                              Picker("Select Label", selection: $viewModel.selectedLabel) {
                                  Text("No Selected").tag(nil as String?)
                                  ForEach(viewModel.labels, id: \.self) { label in
                                      Text(label).tag(label as String?)
                                  }
                              }
                          }
                          
                          // Assignee Section
                          Section(header: Text("Assignee")) {
                              Picker("Select Assignee", selection: $viewModel.selectedAssignee) {
                                  Text("No Selected").tag(nil as String?)
                                  ForEach(viewModel.assignees, id: \.self) { assignee in
                                      Text(assignee).tag(assignee as String?)
                                  }
                              }
                          }
                    
                    // Images Section
                    ImageSectionView(selectedImages: $viewModel.selectedImages)
                    
                    // Description Section
                    Section(header: Text("Description")) {
                        TextField("Enter bug description", text: $viewModel.bug.description)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    // Submit Button
                    Button(action: {
                        viewModel.updateBug()
                        showPopup = true
                    }) {
                        Text("Submit Bug")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                }
                .navigationTitle("Submit Bug")
            }
            
            // Popup
            if showPopup {
                BugSubmissionPopup(
                    isJiraSelected: $isJiraSelected,
                    isNotionSelected: $isNotionSelected,
                    submitAction: {
                        viewModel.submitBug(selectedToJira: isJiraSelected, selectedToNotion: isNotionSelected)
                        showPopup = false
                    },
                    cancelAction: {
                        showPopup = false
                    }
                )
            }
            
            // Display loading overlay when isLoading is true
            if viewModel.isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ProgressView("Submitting...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
            }
        }
    }
}
