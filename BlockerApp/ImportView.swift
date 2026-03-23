import SwiftUI
import UniformTypeIdentifiers

struct ImportView: View {
    @EnvironmentObject var store: BlacklistStore
    @State private var pasteText = ""
    @State private var showFilePicker = false
    @State private var importResult: String? = nil
    @State private var showIOSGuide = false

    var body: some View {
        NavigationView {
            Form {
                // MARK: Importa da file
                Section(header: Text("Importa da file CSV / TXT"),
                        footer: Text("Formato: un numero per riga, opzionalmente: numero,etichetta")) {
                    Button(action: { showFilePicker = true }) {
                        Label("Scegli file...", systemImage: "doc.badge.plus")
                    }
                    .fileImporter(
                        isPresented: $showFilePicker,
                        allowedContentTypes: [.plainText, .commaSeparatedText, UTType(filenameExtension: "csv")!],
                        allowsMultipleSelection: false
                    ) { result in
                        handleFileImport(result)
                    }
                }

                // MARK: Incolla testo
                Section(header: Text("Oppure incolla i numeri"),
                        footer: Text("Incolla una lista di numeri, uno per riga")) {
                    TextEditor(text: $pasteText)
                        .frame(minHeight: 120)
                        .font(.system(.body, design: .monospaced))

                    Button(action: importFromPaste) {
                        Label("Importa dalla lista", systemImage: "square.and.arrow.down")
                            .foregroundColor(.orange)
                    }
                    .disabled(pasteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                // MARK: Sincronizza con iOS
                Section(header: Text("Numeri già bloccati su iOS")) {
                    Button(action: { showIOSGuide = true }) {
                        Label("Come importare i bloccati di iOS", systemImage: "info.circle")
                            .foregroundColor(.green)
                    }
                }

                // MARK: Risultato
                if let result = importResult {
                    Section {
                        Label(result, systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }

                // MARK: Esempio formato
                Section(header: Text("Esempio formato file")) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("+393331234567,Telemarketing")
                            .font(.system(.caption, design: .monospaced))
                        Text("+390212345678,Numero sconosciuto")
                            .font(.system(.caption, design: .monospaced))
                        Text("+393491234567")
                            .font(.system(.caption, design: .monospaced))
                    }
                    .padding(.vertical, 4)
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Importa Numeri")
            .sheet(isPresented: $showIOSGuide) {
                IOSSyncGuideView()
            }
        }
    }

    func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            _ = url.startAccessingSecurityScopedResource()
            defer { url.stopAccessingSecurityScopedResource() }
            if let text = try? String(contentsOf: url, encoding: .utf8) {
                let added = store.importFromText(text)
                importResult = "✅ Importati \(added) nuovi numeri dal file"
            }
        case .failure(let error):
            importResult = "❌ Errore: \(error.localizedDescription)"
        }
    }

    func importFromPaste() {
        let added = store.importFromText(pasteText)
        importResult = "✅ Importati \(added) nuovi numeri"
        pasteText = ""
    }
}

struct IOSSyncGuideView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Perché non è automatico")) {
                    Text("Apple non consente alle app di leggere la lista dei numeri bloccati nativamente per motivi di privacy. Puoi però importarli manualmente in pochi passaggi.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                }

                Section(header: Text("Metodo 1 – Esporta da Impostazioni iOS")) {
                    StepRow(n: 1, text: "Vai in Impostazioni → Telefono")
                    StepRow(n: 2, text: "Tocca \"Bloccati e ID chiamante\"")
                    StepRow(n: 3, text: "Prendi nota o fai uno screenshot dei numeri")
                    StepRow(n: 4, text: "Torna in questa app e inseriscili nella scheda \"Aggiungi\" o incollali nella scheda \"Importa\"")
                }

                Section(header: Text("Metodo 2 – Backup iCloud")) {
                    Text("Se hai un backup iCloud recente, i numeri bloccati sono già inclusi. Quando installi questa app su un nuovo dispositivo, i blocchi iOS verranno ripristinati automaticamente dal backup.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                }

                Section(header: Text("Consiglio")) {
                    Label("Usa questa app come lista unica: aggiungi qui tutti i numeri e usa CallKit per bloccarli. È più potente del blocco nativo iOS perché supporta liste grandi e importazione in bulk.", systemImage: "lightbulb.fill")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                }
            }
            .navigationTitle("Sync con iOS")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Chiudi") { dismiss() }
                }
            }
        }
    }
}

struct StepRow: View {
    let n: Int
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(n)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
                .background(Color.green)
                .clipShape(Circle())
            Text(text)
                .font(.subheadline)
        }
        .padding(.vertical, 2)
    }
}
