//
//  CustomPopupView.swift
//  Bug Submission Screen
//
//  Created by  Abdallah Omar on 08/09/2024.
//

import SwiftUI

struct BugSubmissionPopup: View {
    
    @Binding var isJiraSelected: Bool
    @Binding var isNotionSelected: Bool
    
    var submitAction: () -> Void
    var cancelAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select an Option")
                .font(.headline)
            
            Toggle(isOn: $isJiraSelected) {
                Text("Jira")
            }
            .toggleStyle(CheckboxToggleStyle())
            
            Toggle(isOn: $isNotionSelected) {
                Text("Notion")
            }
            .toggleStyle(CheckboxToggleStyle())
            
            HStack {
                Button("OK", action: submitAction)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                Button("Cancel", action: cancelAction)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        .frame(width: 300)
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .onTapGesture { configuration.isOn.toggle() }
            configuration.label
        }
    }
}
