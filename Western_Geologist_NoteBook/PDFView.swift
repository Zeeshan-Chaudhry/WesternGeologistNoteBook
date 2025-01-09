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
        .onAppear {
            // Load PDFs from the Documents directory
            loadPDFs()
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
                // Save the imported PDF to Documents directory
                saveFileToDocumentsDirectory(sourceURL: url)
                loadPDFs() // Refresh the list
                isShowingPicker = false
            }
        }
    }

    private func loadPDFs() {
        // Load files from the Documents directory and update the pdfs array
        let files = loadFilesFromDocumentsDirectory()
        pdfs = files.map { PDFItem(name: $0.lastPathComponent, url: $0) }
    }

    private func deletePDF(at offsets: IndexSet) {
        for index in offsets {
            let file = pdfs[index]
            do {
                try FileManager.default.removeItem(at: file.url)
                print("File deleted successfully: \(file.name)")
            } catch {
                print("Failed to delete file: \(error.localizedDescription)")
            }
        }
        pdfs.remove(atOffsets: offsets)
    }

    // MARK: - File Management
    private func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    private func saveFileToDocumentsDirectory(sourceURL: URL) {
        guard let documentsDirectory = getDocumentsDirectory() else {
            print("Unable to locate Documents directory.")
            return
        }

        let destinationURL = documentsDirectory.appendingPathComponent(sourceURL.lastPathComponent)

        if FileManager.default.fileExists(atPath: destinationURL.path) {
            print("File already exists at \(destinationURL.path).")
        } else {
            do {
                try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                print("File successfully copied to \(destinationURL.path).")
            } catch {
                print("Failed to copy file: \(error.localizedDescription)")
            }
        }
    }

    private func loadFilesFromDocumentsDirectory() -> [URL] {
        guard let documentsDirectory = getDocumentsDirectory() else { return [] }
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            return files.filter { $0.pathExtension == "pdf" }
        } catch {
            print("Failed to load files: \(error.localizedDescription)")
            return []
        }
    }
}
