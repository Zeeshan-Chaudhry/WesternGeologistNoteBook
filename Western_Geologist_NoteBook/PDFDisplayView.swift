import SwiftUI
import PDFKit

struct PDFDisplayView: View {
    let pdfURL: URL

    var body: some View {
        VStack {
            PDFKitRepresentedView(url: pdfURL)
                .edgesIgnoringSafeArea(.all)
        }
        .navigationBarTitle("PDF Viewer", displayMode: .inline)
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFKit.PDFView, context: Context) {}
}

struct PDFDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        PDFDisplayView(pdfURL: URL(fileURLWithPath: "/path/to/sample.pdf"))
    }
}
