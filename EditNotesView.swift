import SwiftUI

struct EditNoteView: View {
    @State private var editedTitle: String
    @State private var editedContent: String
    var note: Note
    var onSave: (Note) -> Void

    @Environment(\.presentationMode) private var presentationMode // To dismiss the view

    init(note: Note, onSave: @escaping (Note) -> Void) {
        self.note = note
        self.onSave = onSave
        _editedTitle = State(initialValue: note.title)
        _editedContent = State(initialValue: note.content)
    }

    var body: some View {
        VStack {
            TextField("Edit Title", text: $editedTitle)
                .font(.title)
                .padding()
                .border(Color.gray, width: 1)

            TextEditor(text: $editedContent)
                .padding()
                .border(Color.gray, width: 1)

            Button(action: {
                let updatedNote = Note(id: note.id, title: editedTitle, content: editedContent)
                onSave(updatedNote)
                presentationMode.wrappedValue.dismiss() // Dismiss the view after saving
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
