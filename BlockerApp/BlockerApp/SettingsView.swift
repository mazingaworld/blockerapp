import SwiftUI
import CallKit

struct SettingsView: View {
    @EnvironmentObject var store: BlacklistStore
    @State private var extensionEnabled = false
    @State private var showClearConfirm = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Stato blocco chiamate")) {
                    HStack {
                        Label("CallKit Extension", systemImage: "shield.fill")
                        Spacer()
                        Image(systemName: extensionEnabled ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(extensionEnabled ? .green : .red)
                    }

                    Button(action: {
                        // Apri Impostazioni → Telefono → Blocco e ID chiamante
                        if let url = URL(string: "App-Prefs:root=Phone") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Label("Attiva in Impostazioni iOS", systemImage: "arrow.up.right.square")
                            .foregroundColor(.blue)
                    }

                    Button(action: { store.reloadExtension() }) {
                        Label("Ricarica Extension", systemImage: "arrow.clockwise")
                            .foregroundColor(.orange)
                    }
                }

                Section(header: Text("Statistiche")) {
                    LabeledContent("Numeri bloccati", value: "\(store.numbers.count)")
                    LabeledContent("Inseriti manualmente", value: "\(store.numbers.filter { $0.source == .manual }.count)")
                    LabeledContent("Importati da file", value: "\(store.numbers.filter { $0.source == .imported }.count)")
                    if let date = store.lastSyncDate {
                        LabeledContent("Ultimo aggiornamento", value: date.formatted(date: .abbreviated, time: .shortened))
                    }
                }

                Section(header: Text("Guida rapida")) {
                    InfoRow(icon: "shield.fill", color: .red, text: "Vai in Impostazioni → Telefono → Blocco chiamate e ID chiamante → attiva \"BlockerApp\"")
                    InfoRow(icon: "arrow.clockwise", color: .orange, text: "Ogni volta che modifichi la lista, l'extension si ricarica automaticamente")
                    InfoRow(icon: "exclamationmark.triangle.fill", color: .yellow, text: "Con account gratuito Apple, l'app funziona 7 giorni poi va reinstallata via Xcode")
                }

                Section {
                    Button(role: .destructive, action: { showClearConfirm = true }) {
                        Label("Cancella tutta la blacklist", systemImage: "trash.fill")
                    }
                }
            }
            .navigationTitle("Impostazioni")
            .onAppear(perform: checkExtensionStatus)
            .confirmationDialog("Sei sicuro?", isPresented: $showClearConfirm, titleVisibility: .visible) {
                Button("Cancella tutto", role: .destructive) {
                    store.numbers.removeAll()
                    store.save()
                    store.reloadExtension()
                }
                Button("Annulla", role: .cancel) {}
            } message: {
                Text("Verranno rimossi tutti i \(store.numbers.count) numeri bloccati.")
            }
        }
    }

    func checkExtensionStatus() {
        CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(
            withIdentifier: "com.tuonome.blockerapp.CallBlockerExtension"
        ) { status, _ in
            DispatchQueue.main.async {
                extensionEnabled = (status == .enabled)
            }
        }
    }
}
