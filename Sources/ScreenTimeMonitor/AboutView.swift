import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Screen Time Monitor")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Version 1.0")
                .font(.subheadline)
            
            Text("This app monitors your screen time limits and alerts you when they are reached.")
                .multilineTextAlignment(.center)
                .padding()
            
            Text("© 2025 Your Name")
                .font(.caption)
            
            Button("Close") {
                NSApplication.shared.keyWindow?.close()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding(30)
        .frame(width: 350, height: 250)
    }
}

#Preview {
    AboutView()
}
