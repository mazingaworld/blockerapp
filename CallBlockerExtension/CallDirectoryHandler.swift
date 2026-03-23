import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {

    private let appGroupID = "group.com.tuonome.blockerapp" // ← deve corrispondere all'app principale

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self

        // Carica la blacklist dall'App Group condiviso
        let numbers = loadBlockedNumbers()

        if numbers.isEmpty {
            context.completeRequest()
            return
        }

        // Aggiungi i numeri da bloccare - devono essere in ordine crescente
        let sorted = numbers
            .map { normalize($0) }
            .compactMap { CXCallDirectoryPhoneNumber($0) }
            .sorted()

        for number in sorted {
            context.addBlockingEntry(withNextSequentialPhoneNumber: number)
        }

        context.completeRequest()
    }

    // MARK: - Load numbers from shared App Group

    private func loadBlockedNumbers() -> [String] {
        guard let url = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupID)?
            .appendingPathComponent("blocklist.json"),
              let data = try? Data(contentsOf: url),
              let entries = try? JSONDecoder().decode([BlockedEntry].self, from: data)
        else {
            return []
        }
        return entries.map { $0.number }
    }

    private func normalize(_ number: String) -> String {
        return number.filter { $0.isNumber || $0 == "+" }
    }
}

// Minimal decodable struct (mirrors BlockedNumber in main app)
private struct BlockedEntry: Decodable {
    let number: String
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        print("CallDirectoryHandler error: \(error.localizedDescription)")
    }
}
