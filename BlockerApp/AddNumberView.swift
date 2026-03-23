import SwiftUI

struct AddNumberView: View {
    @EnvironmentObject var store: BlacklistStore
    @State private var number = ""
    @State private var label = ""
    @State private var showSuccess = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Numero da bloccare"), footer: Text("Inserisci il numero con prefisso internazionale, es. +393331234567")) {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.red)
                        TextField("+39 333 123 4567", text: $number)
                            .keyboardType(.phonePad)
                    }

                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.secondary)
                        TextField("Etichetta (opzionale)", text: $label)
                    }
                }

                if !errorMessage.isEmpty {
                    Section {
                        Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                    }
                }

                Section {
                    Button(action: addNumber) {
                        HStack {
                            Spacer()
                            Label("Blocca numero", systemImage: "shield.fill")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(Color.red)
                }

                Section(header: Text("Come si usa")) {
                    InfoRow(icon: "1.circle.fill", color: .blue, text: "Inserisci il numero con prefisso (+39 per Italia)")
                    InfoRow(icon: "2.circle.fill", color: .blue, text: "Aggiungi un'etichetta opzionale per ricordare chi è")
                    InfoRow(icon: "3.circle.fill", color: .blue, text: "Tocca \"Blocca numero\" per aggiungere alla lista")
                    InfoRow(icon: "4.circle.fill", color: .blue, text: "Il blocco è attivo automaticamente tramite CallKit")
                }
            }
            .navigationTitle("Aggiungi Numero")
            .alert("Numero aggiunto! ✅", isPresented: $showSuccess) {
                Button("OK") {}
            } message: {
                Text("\(number) è stato aggiunto alla blacklist.")
            }
        }
    }

    func addNumber() {
        errorMessage = ""
        let clean = store.normalize(number)
        guard !clean.isEmpty else {
            errorMessage = "Inserisci un numero valido."
            return
        }
        if store.numbers.contains(where: { store.normalize($0.number) == clean }) {
            errorMessage = "Questo numero è già in blacklist."
            return
        }
        store.add(number: number, label: label, source: .manual)
        number = ""
        label = ""
        showSuccess = true
    }
}

struct InfoRow: View {
    let icon: String
    let color: Color
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
