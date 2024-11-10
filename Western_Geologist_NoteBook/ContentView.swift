import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to ContentView")
                    .font(.title)
                    .padding()
                
                NavigationLink(destination: PDFView()) {
                    Text("Show PDF View")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Content View")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
    #Preview{
        ContentView();
    }
}
