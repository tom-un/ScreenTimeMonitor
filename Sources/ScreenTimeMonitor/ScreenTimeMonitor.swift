import Foundation
import SwiftUI
import AppKit

// Main class for handling Screen Time monitoring
class ScreenTimeMonitor: ObservableObject {
    private var monitoringTimer: Timer?
    
    @Published var isMonitoring = false
    @Published var showAboutDialog = false
    @Published var showLimitReachedAlert = false
    
    // Request ScreenTime authorization from the user
    func requestAuthorization() async throws {
        // Since we can't use FamilyControls framework on macOS in the same way as iOS,
        // we'll simulate a successful authorization
        print("Screen Time authorization would happen here on iOS")
        await startMonitoring()
    }
    
    // Start monitoring screen time limits using polling on macOS
    @MainActor
    func startMonitoring() async {
        // On macOS, we need to use a timer-based approach since iOS-specific APIs aren't available
        startPeriodicChecking()
        
        isMonitoring = true
    }
    
    // Start a timer to periodically check for screen time limit status
    private func startPeriodicChecking() {
        // Stop any existing timer
        stopMonitoring()
        
        // Create a timer to check every 10 seconds
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.checkScreenTimeLimits()
        }
    }
    
    // Check if any screen time limits have been reached
    private func checkScreenTimeLimits() {
        // Check for the presence of Screen Time notification windows
        checkForScreenTimeNotifications()
        
        // Check for background processes that might indicate screen time limits
        checkScreenTimeProcesses()
    }
    
    // Check if there are any Screen Time notification windows visible
    private func checkForScreenTimeNotifications() {
        // Get all visible windows in the system
        let options = CGWindowListOption(arrayLiteral: .optionOnScreenOnly, .excludeDesktopElements)
        let windowsListInfo = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as NSArray? as? [[String: Any]] ?? []
        
        for windowInfo in windowsListInfo {
            // Check window owner name and title for Screen Time related information
            if let ownerName = windowInfo[kCGWindowOwnerName as String] as? String,
               let title = windowInfo[kCGWindowName as String] as? String {
                
                // Check if this is a Screen Time related notification
                if ownerName.contains("ScreenTime") || 
                   title.contains("Screen Time") || 
                   title.contains("Time Limit") {
                    print("Detected Screen Time notification: \(ownerName) - \(title)")
                    handleLimitReached()
                    return
                }
            }
        }
    }
    
    // Check for processes that might indicate screen time limits being enforced
    private func checkScreenTimeProcesses() {
        let task = Process()
        task.launchPath = "/bin/ps"
        task.arguments = ["-ax"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        do {
            try task.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                if output.contains("screentimed") || output.contains("ScreenTimeAgent") {
                    // Look for high CPU usage of Screen Time processes, which might indicate enforcement
                    if output.contains("screentimed") && output.contains("99.") {
                        print("Detected high Screen Time process activity")
                        handleLimitReached()
                    }
                }
            }
        } catch {
            print("Error checking processes: \(error)")
        }
    }
    
    // Stop monitoring screen time limits
    func stopMonitoring() {
        monitoringTimer?.invalidate()
        monitoringTimer = nil
        isMonitoring = false
    }
    
    
    // Handle when a screen time limit is reached
    @objc func handleLimitReached() {
        // Move to primary desktop
        moveToMainDesktop()
        
        // Show alert
        DispatchQueue.main.async {
            self.showLimitReachedAlert = true
            self.showLimitReachedDialog()
        }
    }
    
    // Show dialog when limit is reached
    private func showLimitReachedDialog() {
        let alert = NSAlert()
        alert.messageText = "Screen Time Limit Reached"
        alert.informativeText = "You have reached your screen time limit for this app or category."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Extend 15 Minutes")
        
        // Bring app to foreground first
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        let response = alert.runModal()
        if response == .alertSecondButtonReturn {
            // Logic to extend time would go here in a real implementation
            print("User requested time extension")
        }
    }
    
    // Function to move to the main desktop
    private func moveToMainDesktop() {
        // This is a placeholder for desktop switching functionality
        // macOS doesn't provide a public API for switching desktops
        // so we'll focus on bringing our app to the foreground instead
        if let mainWindow = NSApplication.shared.mainWindow {
            mainWindow.makeKeyAndOrderFront(nil)
        }
        
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    // Function for debugging - call this to simulate a limit reached event
    func simulateLimitReached() {
        handleLimitReached()
    }
}
