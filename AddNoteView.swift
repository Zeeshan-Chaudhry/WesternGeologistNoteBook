import SwiftUI

struct AddNoteView: View {
    var onAdd: (Note) -> Void
    @State private var newTitle: String = ""
    @State private var newContent: String = ""

    var body: some View {
        VStack {
            TextField("Enter Title", text: $newTitle)
                .font(.title)
                .padding()
                .border(Color.gray, width: 1)

            TextEditor(text: $newContent)
                .padding()
                .border(Color.gray, width: 1)

            Button(action: {
                let newNote = Note(title: newTitle.isEmpty ? "Untitled" : newTitle, content: newContent)
                onAdd(newNote)
            }) {
                Text("Add")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
            }
            .disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                      newContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
    }
}
