import SwiftUI

struct BlacklistView: View {
    @EnvironmentObject var store: BlacklistStore
    @State private var searchText = ""
    @State private var showDeleteConfirm = false
    @State private var numberToDelete: BlockedNumber? = nil

    var filtered: [BlockedNumber] {
        if searchText.isEmpty { return store.sortedNumbers }
        return store.sortedNumbers.filter {
            $0.number.contains(searchText) || $0.label.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if store.numbers.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "shield.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text("Nessun numero bloccato")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Aggiungi numeri dalla scheda \"Aggiungi\" o importa una lista.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        Section(header: Text("\(store.numbers.count) numero/i bloccato/i")) {
                            ForEach(filtered) { entry in
                                NumberRow(entry: entry)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            store.remove(id: entry.id)
                                        } label: {
                                            Label("Rimuovi", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                    .searchable(text: $searchText, prompt: "Cerca numero o etichetta")
                }
            }
            .navigationTitle("🛡️ Blacklist")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { store.reloadExtension() }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}

struct NumberRow: View {
    let entry: BlockedNumber

    var sourceColor: Color {
        switch entry.source {
        case .manual: return .blue
        case .imported: return .orange
        case .ios: return .green
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: "phone.down.fill")
                    .foregroundColor(.red)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.number)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.semibold)
                if !entry.label.isEmpty {
                    Text(entry.label)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(entry.dateAdded, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(entry.source.rawValue)
                .font(.caption2)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(sourceColor.opacity(0.15))
                .foregroundColor(sourceColor)
                .cornerRadius(6)
        }
        .padding(.vertical, 4)
    }
}
