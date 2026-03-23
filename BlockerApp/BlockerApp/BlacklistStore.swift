import Foundation
import CallKit
import Combine

struct BlockedNumber: Identifiable, Codable, Hashable {
    var id = UUID()
    var number: String
    var label: String
    var dateAdded: Date
    var source: Source

    enum Source: String, Codable {
        case manual = "Manuale"
        case imported = "Importato"
        case ios = "iOS"
    }
}

class BlacklistStore: ObservableObject {
    static let shared = BlacklistStore()

    @Published var numbers: [BlockedNumber] = []
    @Published var lastSyncDate: Date? = nil
    @Published var isSyncing: Bool = false

    private let saveKey = "blocked_numbers"
    private let appGroupID = "group.com.tuonome.blockerapp" // ← cambia con il tuo App Group ID

    init() {
        load()
    }

    // MARK: - CRUD

    func add(number: String, label: String = "", source: BlockedNumber.Source = .manual) {
        let clean = normalize(number)
        guard !clean.isEmpty, !numbers.contains(where: { normalize($0.number) == clean }) else { return }
        let entry = BlockedNumber(number: clean, label: label, dateAdded: Date(), source: source)
        numbers.insert(entry, at: 0)
        save()
        reloadExtension()
    }

    func remove(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
        save()
        reloadExtension()
    }

    func remove(id: UUID) {
        numbers.removeAll { $0.id == id }
        save()
        reloadExtension()
    }

    func importFromText(_ text: String) -> Int {
        let lines = text.components(separatedBy: .newlines)
        var added = 0
        for line in lines {
            let parts = line.components(separatedBy: ",")
            let number = parts.first?.trimmingCharacters(in: .whitespaces) ?? ""
            let label = parts.count > 1 ? parts[1].trimmingCharacters(in: .whitespaces) : ""
            if !number.isEmpty {
                let clean = normalize(number)
                if !numbers.contains(where: { normalize($0.number) == clean }) {
                    let entry = BlockedNumber(number: clean, label: label, dateAdded: Date(), source: .imported)
                    numbers.insert(entry, at: 0)
                    added += 1
                }
            }
        }
        if added > 0 {
            save()
            reloadExtension()
        }
        return added
    }

    // MARK: - Sync with iOS blocked numbers

    func syncWithiOSBlockedNumbers() {
        // iOS non espone la lista dei numeri bloccati via API per privacy.
        // Questa funzione mostra un promemoria all'utente su come esportarli.
        isSyncing = false
        lastSyncDate = Date()
    }

    // MARK: - Persistence

    func save() {
        if let data = try? JSONEncoder().encode(numbers) {
            // Salva nell'App Group per condivisione con l'extension
            if let url = containerURL() {
                try? data.write(to: url)
            }
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    func load() {
        // Prova prima dall'App Group
        if let url = containerURL(), let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([BlockedNumber].self, from: data) {
            numbers = decoded
            return
        }
        // Fallback su UserDefaults
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([BlockedNumber].self, from: data) {
            numbers = decoded
        }
    }

    private func containerURL() -> URL? {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupID)?
            .appendingPathComponent("blocklist.json")
    }

    // MARK: - CallKit Reload

    func reloadExtension() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(
            withIdentifier: "com.tuonome.blockerapp.CallBlockerExtension"
        ) { error in
            if let error = error {
                print("Errore reload extension: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Helpers

    func normalize(_ number: String) -> String {
        let digits = number.filter { $0.isNumber || $0 == "+" }
        return digits
    }

    var sortedNumbers: [BlockedNumber] {
        numbers.sorted { $0.dateAdded > $1.dateAdded }
    }
}
