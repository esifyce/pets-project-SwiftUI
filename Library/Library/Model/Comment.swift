//
//  Comment.swift
//  Library
//
//  Created by Krasivo on 13.12.2023.
//

import Foundation
import SwiftData

@Model
class Comment {
    var creationDate: Date = Date.now
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
    var book: Book?
}
