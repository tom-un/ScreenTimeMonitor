# Screen Time Monitor Specification

## Overview
Screen Time Monitor is a macOS application that monitors and detects when Screen Time limits are reached on the system. It provides a custom interface to display notifications and allows users to test the notification functionality.

## System Requirements
- macOS 12.0 or later
- Swift 5.7 or later
- Xcode 16 or later (for development)

## Features

### 1. Core Functionality
- **Screen Time Limit Detection**: Monitors the system for Screen Time limit notifications
- **Custom Notification Dialog**: Displays a custom dialog when limits are reached
- **Manual Testing**: Provides a "Test Limit Reached" button to simulate and test the notification functionality

### 2. User Interface
- **Authorization Interface**: Simple button to authorize Screen Time monitoring
- **Monitoring Status**: Clearly displays whether monitoring is active
- **About Dialog**: Contains information about the application

### 3. Window Management
- **Always-on-Top Window**: Uses window level `.screenSaver` to ensure the app stays visible
- **Window Persistence**: Implements continuous window elevation to keep the app accessible
- **Custom Window Creation**: Explicitly creates and manages the application window

### 4. Screen Time Detection Methods
- **Window Notification Scanner**: Detects Screen Time notification windows
- **Process Monitoring**: Monitors Screen Time-related processes for activity

## Technical Requirements

### Window Management
- The application window must stay on top of other windows (except during Xcode debugging)
- The window must be brought to the foreground when Screen Time limits are triggered
- Window creation must be handled explicitly to ensure proper display

### Detection Logic
- The app must scan for visible notification windows from Screen Time
- Process monitoring must identify high CPU usage of Screen Time processes
- The detection system must check every 10 seconds for potential limit triggers

### UI Requirements
- The UI must clearly indicate when monitoring is active
- The app must provide a manual test feature for limit detection
- The app must support showing a custom dialog with options to acknowledge or extend time

## Architecture

### Main Components
1. **ScreenTimeMonitorApp**: The main entry point and SwiftUI App structure
2. **AppDelegate**: Handles application lifecycle and window creation
3. **ScreenTimeMonitor**: The core class managing monitoring and detection
4. **ContentView**: The main user interface
5. **AboutView**: Information dialog about the application

### Key Interactions
- The AppDelegate creates and manages the main window
- The ScreenTimeMonitor class runs periodic checks for limit triggers
- The ContentView displays status and provides user control
- Custom notifications appear when limits are detected

## Limitations
- macOS provides limited API access to Screen Time data compared to iOS
- Detection is based on indirect methods like window scanning and process monitoring
- The app window may appear behind Xcode during debugging
