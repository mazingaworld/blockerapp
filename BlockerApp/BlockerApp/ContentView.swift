import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: BlacklistStore

    var body: some View {
        TabView {
            BlacklistView()
                .tabItem {
                    Label("Blacklist", systemImage: "shield.fill")
                }

            AddNumberView()
                .tabItem {
                    Label("Aggiungi", systemImage: "plus.circle.fill")
                }

            ImportView()
                .tabItem {
                    Label("Importa", systemImage: "square.and.arrow.down.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Impostazioni", systemImage: "gear")
                }
        }
        .accentColor(.red)
    }
}
