//
//  Bug.swift
//  Bug Submission Screen
//
//  Created by  Abdallah Omar on 03/09/2024.
//

import Foundation
import SwiftUI

struct Bug: Identifiable {
    let id = UUID()
    var description: String
    var priority: String
     var images: [UIImage]
    var labels: [String]
    var assignee: String
}
