import SwiftUI
import AppKit

@main
struct ScreenTimeMonitorApp: App {
    @StateObject private var screenTimeMonitor = ScreenTimeMonitor()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(screenTimeMonitor)
                .onAppear {
                    NSApplication.shared.activate(ignoringOtherApps: true)
                }
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About ScreenTimeMonitor") {
                    screenTimeMonitor.showAboutDialog = true
                }
            }
        }
    }
}

// Add an AppDelegate to ensure proper application activation
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("Application did finish launching")
        
        // Ensure the app is activated and visible
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        // Print window information for debugging
        print("Number of windows: \(NSApplication.shared.windows.count)")
        for (index, window) in NSApplication.shared.windows.enumerated() {
            print("Window \(index): \(window)")
        }
        
        // If there's no window visible yet, create one explicitly
        if NSApplication.shared.windows.isEmpty {
            print("Creating window explicitly")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.createAndShowWindow()
            }
        } else {
            // If we have a key window, bring it to the front
            if let window = NSApplication.shared.windows.first {
                window.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    private func createAndShowWindow() {
        // Create a hosting controller with the ContentView
        let contentView = ContentView()
            .environmentObject(ScreenTimeMonitor())
        let hostingController = NSHostingController(rootView: contentView)
        
        // Create the window
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 320),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        // Configure the window
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = hostingController.view
        window.title = "Screen Time Monitor"
        
        // Ensure the window stays in front even above Xcode
        window.level = .screenSaver  // One of the highest window levels
        window.orderFrontRegardless()
        window.makeKeyAndOrderFront(nil)
        
        // Add a timer to keep bringing the window to front
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            if let window = self?.window {
                window.orderFrontRegardless()
                NSApplication.shared.activate(ignoringOtherApps: true)
            } else {
                timer.invalidate()
            }
        }
        
        // Keep a strong reference to the window
        self.window = window
        
        // Activate the app again
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
}
