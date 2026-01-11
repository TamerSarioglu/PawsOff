import SwiftUI

@main
struct PawsOffApp: App {
    @StateObject private var keyboardManager = KeyboardManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(keyboardManager)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 340, height: 420)
    }
}
