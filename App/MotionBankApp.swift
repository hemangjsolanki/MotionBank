import SwiftUI

@main
struct MotionBankApp: App {
    @StateObject private var globalState = GlobalState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withNotificationBanner()
                .environmentObject(globalState)
                // Enforce Dark Mode for the premium look as requested
                .preferredColorScheme(.dark)
        }
    }
}
