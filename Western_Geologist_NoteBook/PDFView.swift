import SwiftUI
import PDFKit

// PDF item model
struct PDFItem: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
}

struct PDFView: View {
    @State private var pdfs: [PDFItem] = [] // List of imported PDFs
    @State private var isShowingPicker = false // Document picker visibility
    @State private var selectedPDF: PDFItem? = nil // Selected PDF

    var body: some View {
        VStack {
            List {
                ForEach(pdfs) { pdf in
                    Button(action: {
                        selectedPDF = pdf
                    }) {
                        HStack {
                            Text(pdf.name)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .onDelete(perform: deletePDF) // Swipe to delete
            }
            .sheet(item: $selectedPDF) { pdfItem in
                PDFDisplayView(pdfURL: pdfItem.url) // Show PDF content
            }
        }
        .navigationTitle("PDFs")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    isShowingPicker = true
                }) {
                    Image(systemName: "square.and.arrow.down")
                }
            }
        }
        .sheet(isPresented: $isShowingPicker) {
            CustomDocumentPicker { url in
                let pdfItem = PDFItem(name: url.lastPathComponent, url: url)
                pdfs.append(pdfItem) // Add imported PDF
                isShowingPicker = false
            }
        }
    }

    private func deletePDF(at offsets: IndexSet) {
        pdfs.remove(atOffsets: offsets)
    }
}

struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        PDFView()
    }
    #Preview{
        PDFView()
    }
}
