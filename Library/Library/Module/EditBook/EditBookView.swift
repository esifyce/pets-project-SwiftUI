//
//  EditBookView.swift
//  Library
//
//  Created by Krasivo on 12.12.2023.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    let book: Book
    
    @State private var status = Status.onShelf
    @State private var rating: Int?
    @State private var title = ""
    @State private var author = ""
    @State private var summary = ""
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast
    @State private var firstView = true
    @State private var recommendedBy = ""
    @State private var showGenres = false

    var body: some View {
        HStack {
            Text("Статус")
            Picker("Статус", selection: $status) {
                ForEach(Status.allCases) { status in
                    Text(status.descr).tag(status)
                }
            }
            .buttonStyle(.bordered)
        }
        VStack(alignment: .leading) {
            GroupBox {
                LabeledContent {
                    DatePicker("", selection: $dateAdded, displayedComponents: .date)
                } label: {
                    Text("Дата добавление")
                }
                if status == .inProgress || status == .completed {
                    LabeledContent {
                        DatePicker(
                            "",
                            selection: $dateStarted,
                            in: dateAdded...,
                            displayedComponents: .date
                        )
                    } label: {
                        Text("Дата начало")
                    }
                }
                
                if status == .completed {
                    LabeledContent {
                        DatePicker(
                            "",
                            selection: $dateCompleted,
                            in: dateStarted...,
                            displayedComponents: .date
                        )
                    } label: {
                        Text("Дата окончание")
                    }
                }
            }
            .foregroundStyle(.secondary)
            .onChange(of: status) { oldValue, newValue in
                if !firstView {
                    if newValue == .onShelf {
                        dateStarted = Date.distantPast
                        dateCompleted = Date.distantPast
                    } else if newValue == .inProgress && oldValue == .completed {
                        dateCompleted = Date.distantPast
                    } else if newValue == .inProgress && oldValue == .onShelf {
                        dateStarted = Date.now
                    } else if newValue == .completed && oldValue == .onShelf {
                        dateCompleted = Date.now
                        dateStarted = dateAdded
                    } else {
                        dateCompleted = Date.now
                    }
                    firstView = false
                }
            }
            Divider()
            LabeledContent {
                RatingsView(maxRating: 5, currentRating: $rating, width: 40)
            } label: {
                Text("Рейтинг")
            }
            
            LabeledContent {
                TextField("", text: $title)
            } label: {
                Text("Заголовок").foregroundStyle(.secondary)
            }
            
            LabeledContent {
                TextField("", text: $author)
            } label: {
                Text("Автор").foregroundStyle(.secondary)
            }
            
            LabeledContent {
                TextField("", text: $recommendedBy)
            } label: {
                Text("Рекомендует").foregroundStyle(.secondary)
            }
            Divider()
            Text("Краткий обзор").foregroundStyle(.secondary)
            TextEditor(text: $summary)
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
            if let genres = book.genres {
                ViewThatFits {
                    GenresStackView(genres: genres)
                    ScrollView(.horizontal, showsIndicators: false) {
                        GenresStackView(genres: genres)
                    }
                }
            }
            
            HStack {
                ViewThatFits {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            NavigationLink {
                                CommentListView(book: book)
                            } label: {
                                let count = book.comments?.count ?? 0
                                Label("\(count) Комментов", systemImage: "list.bullet.rectangle")
                            }
                            Button("Жанры", systemImage: "bookmark.fill") {
                                showGenres.toggle()
                            }
                            .sheet(isPresented: $showGenres) {
                                GenresView(book: book)
                            }
                            NavigationLink {
                                QuotesListView(book: book)
                            } label: {
                                let count = book.quotes?.count ?? 0
                                Label("^[\(count) Цитат](inflect: true)", systemImage: "quote.opening")
                            }
                        }
                        .padding(10)
                    }
                }
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if changed {
                Button("Обновить") {
                    book.status = status.rawValue
                    book.rating = rating
                    book.title = title
                    book.author = author
                    book.summary = summary
                    book.dateAdded = dateAdded
                    book.dateStarted = dateStarted
                    book.dateCompleted = dateCompleted
                    book.recommendedBy = recommendedBy
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            status = Status(rawValue: book.status)!
            rating = book.rating
            title = book.title
            author = book.author
            summary = book.summary
            dateAdded = book.dateAdded
            dateStarted = book.dateStarted
            dateCompleted = book.dateCompleted
            recommendedBy = book.recommendedBy
        }
    }
    
    var changed: Bool {
        status != Status(rawValue: book.status)!
        || rating != book.rating
        || title != book.title
        || author != book.author
        || summary != book.summary
        || dateAdded != book.dateAdded
        || dateStarted != book.dateStarted
        || dateCompleted != book.dateCompleted
        || recommendedBy != book.recommendedBy
    }
}

#Preview {
    let preview = Preview(Book.self)
    return  NavigationStack {
        EditBookView(book: Book.sampleBooks[4])
            .modelContainer(preview.container)
    }
}
