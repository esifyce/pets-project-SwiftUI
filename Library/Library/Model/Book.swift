//
//  Book.swift
//  Library
//
//  Created by Krasivo on 12.12.2023.
//

import SwiftUI
import SwiftData

@Model
class Book {
    var title: String
    var author: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    var summary: String
    var rating: Int?
    var status: Status.RawValue
    var recommendedBy: String
    
    @Relationship(deleteRule: .cascade)
    var quotes: [Quote]?
    @Relationship(deleteRule: .cascade)
    var comments: [Comment]?
    @Relationship(inverse: \Genre.books)
    var genres: [Genre]?
    
    init(
        title: String,
        author: String,
        dateAdded: Date = .now,
        dateStarted: Date = .distantPast,
        dateCompleted: Date = .distantPast,
        summary: String = "",
        rating: Int? = nil,
        status: Status = .onShelf,
        recommendedBy: String = ""
    ) {
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.summary = summary
        self.rating = rating
        self.status = status.rawValue
        self.recommendedBy = recommendedBy
    }
    
    var icon: Image {
        switch Status(rawValue: status)! {
        case .onShelf:
            Image(systemName: "checkmark.diamond.fill")
        case .inProgress:
            Image(systemName: "book.fill")
        case .completed:
            Image(systemName: "books.vertical.fill")
        }
    }
}

enum Status: Int, Codable, Identifiable, CaseIterable {
    case onShelf, inProgress, completed
    var id: Self {
        self
    }
    
    var descr: String {
        switch self {
        case .onShelf:
            "На полке"
        case .inProgress:
            "В чтении"
        case .completed:
            "Прочитано"
        }
    }
}
