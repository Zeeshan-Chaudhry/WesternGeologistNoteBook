import SwiftUI

struct TrashView: View {
    @Binding var trashedNotes: [Note]
    var onRestore: (Note) -> Void

    var body: some View {
        NavigationView {
            List {
                ForEach(trashedNotes) { note in
                    HStack {
                        StickyNoteView(note: note)
                        Spacer()
                        Button(action: {
                            onRestore(note)
                        }) {
                            Text("Restore")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Trash")
        }
    }
}
