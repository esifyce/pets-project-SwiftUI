//
//  CommentView.swift
//  Library
//
//  Created by Krasivo on 13.12.2023.
//

import SwiftUI

struct CommentListView: View {
    @Environment(\.modelContext) private var modelContext
    let book: Book
    @State private var text = ""
    @State private var selectedComment: Comment?
    var isEditing: Bool {
        selectedComment != nil
    }
    var body: some View {
        GroupBox {
            HStack {
                if isEditing {
                    Button("Отменить") {
                        text = ""
                        selectedComment = nil
                    }
                    .buttonStyle(.bordered)
                }
            }
            TextEditor(text: $text)
                .border(Color.secondary)
                .frame(height: 100)
            Button(isEditing ? "Обновить" : "Создать") {
                if isEditing {
                    selectedComment?.text = text
                    text = ""
                    selectedComment = nil
                } else {
                    let comment = Comment(text: text)
                    book.comments?.append(comment)
                    text = ""
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(text.isEmpty)
        }
        .padding(.horizontal)
        List {
            let sortedComments = book.comments?.sorted(using: KeyPathComparator(\Comment.creationDate)) ?? []
            ForEach(sortedComments) { comment in
                VStack(alignment: .leading) {
                    Text(comment.creationDate, format: .dateTime.month().day().year())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(comment.text)
                    HStack {
                        Spacer()
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedComment = comment
                    text = comment.text
                }
            }
            .onDelete { indexSet in
                withAnimation {
                    indexSet.forEach { index in
                        let comment = sortedComments[index]
                        book.comments?.forEach{ bookComment in
                            if comment.id == bookComment.id {
                                modelContext.delete(comment)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Комментарии")
    }
}

#Preview {
    let preview = Preview(Book.self)
    let books = Book.sampleBooks
    preview.addExamples(books)
    return NavigationStack {
        QuotesListView(book: books[4])
            .navigationBarTitleDisplayMode(.inline)
            .modelContainer(preview.container)
    }
}
