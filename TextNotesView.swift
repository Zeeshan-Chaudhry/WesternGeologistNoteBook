import SwiftUI

struct TextNotesView: View {
    @State private var notes: [Note] = []
    @State private var trashedNotes: [Note] = []
    @State private var isAddingNote = false
    @State private var searchText: String = ""
    @State private var selectedNote: Note? = nil // For editing

    private let notesKey = "savedNotes"
    private let trashKey = "trashedNotes"

    var body: some View {
        VStack {
            // Search Bar
            TextField("Search by Title...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Notes Grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                    ForEach(filteredNotes()) { note in
                        VStack {
                            // Tap Gesture for Editing
                            StickyNoteView(note: note)
                                .onTapGesture {
                                    selectedNote = note
                                }

                            // Delete Button
                            Button(action: {
                                deleteNote(note: note)
                            }) {
                                Text("Delete")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.red)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                .padding()
            }

            // Add Note Button
            Button(action: {
                isAddingNote = true
            }) {
                Text("Add Note")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $isAddingNote) {
                AddNoteView(onAdd: { newNote in
                    notes.append(newNote)
                    saveNotes()
                    isAddingNote = false
                })
            }

            // View Trash Button
            if !trashedNotes.isEmpty {
                Button(action: {
                    viewTrash()
                }) {
                    Text("View Trash")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .sheet(item: $selectedNote) { note in
            EditNoteView(note: note) { updatedNote in
                if let index = notes.firstIndex(where: { $0.id == updatedNote.id }) {
                    notes[index] = updatedNote
                    saveNotes()
                }
            }
        }
        .onAppear(perform: loadNotes)
        .navigationTitle("Sticky Notes")
    }

    // MARK: - Filter Notes by Title
    private func filteredNotes() -> [Note] {
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    // MARK: - Delete Note
    private func deleteNote(note: Note) {
        trashedNotes.append(note)
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }

    // MARK: - Save and Load Notes
    private func loadNotes() {
        if let savedNotesData = UserDefaults.standard.data(forKey: notesKey),
           let savedNotes = try? JSONDecoder().decode([Note].self, from: savedNotesData) {
            notes = savedNotes
        }

        if let trashedNotesData = UserDefaults.standard.data(forKey: trashKey),
           let savedTrashedNotes = try? JSONDecoder().decode([Note].self, from: trashedNotesData) {
            trashedNotes = savedTrashedNotes
        }
    }

    private func saveNotes() {
        if let encodedNotes = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encodedNotes, forKey: notesKey)
        }

        if let encodedTrashedNotes = try? JSONEncoder().encode(trashedNotes) {
            UserDefaults.standard.set(encodedTrashedNotes, forKey: trashKey)
        }
    }

    private func viewTrash() {
        let trashView = TrashView(trashedNotes: $trashedNotes, onRestore: { restoredNote in
            notes.append(restoredNote)
            trashedNotes.removeAll { $0.id == restoredNote.id }
            saveNotes()
        })
        let hostingController = UIHostingController(rootView: trashView)
        UIApplication.shared.windows.first?.rootViewController?.present(hostingController, animated: true)
    }
}
