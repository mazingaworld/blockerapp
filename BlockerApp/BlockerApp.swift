import SwiftUI

@main
struct BlockerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(BlacklistStore.shared)
        }
    }
}
