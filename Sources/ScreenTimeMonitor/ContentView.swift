import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var screenTimeMonitor: ScreenTimeMonitor
    @State private var isAuthorized = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Screen Time Monitor")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if isAuthorized {
                Text("Monitoring active")
                    .foregroundColor(.green)
                
                Text("The app will show a dialog when screen time limits are reached.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Test Limit Reached") {
                    screenTimeMonitor.simulateLimitReached()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .padding(.bottom, 8)
                
                Button("Stop Monitoring") {
                    screenTimeMonitor.stopMonitoring()
                    isAuthorized = false
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            } else {
                Text("Waiting for authorization")
                    .foregroundColor(.orange)
                
                Text("This app needs authorization to monitor screen time limits.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Authorize Screen Time Access") {
                    Task {
                        await requestAuthorization()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(30)
        .frame(width: 400, height: 300)
        .onAppear {
            isAuthorized = screenTimeMonitor.isMonitoring
        }
        .sheet(isPresented: $screenTimeMonitor.showAboutDialog) {
            AboutView()
        }
    }
    
    private func requestAuthorization() async {
        do {
            try await screenTimeMonitor.requestAuthorization()
            isAuthorized = true
        } catch {
            print("Authorization failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ScreenTimeMonitor())
}
