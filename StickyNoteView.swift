import SwiftUI

struct StickyNoteView: View {
    var note: Note

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.yellow)
                .shadow(color: .gray, radius: 5, x: 2, y: 2)

            VStack(alignment: .leading) {
                Text(note.title.isEmpty ? "Untitled" : note.title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 5) // Title as a subheading

                Text(note.content)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .lineLimit(5)
                    .truncationMode(.tail)
            }
            .padding()
        }
        .frame(height: 150)
    }
}
