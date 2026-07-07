import Foundation
import Combine

final class LitterlyStore: ObservableObject {
    static let freeTierLimit = 20

    @Published var entries: [LitterEntry] = [] { didSet { persist() } }

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: support, withIntermediateDirectories: true)
        fileURL = support.appendingPathComponent("litterlystore.json")
        load()
    }

    var isAtFreeLimit: Bool { entries.count >= Self.freeTierLimit }

    func canAdd(isPro: Bool) -> Bool {
        isPro || entries.count < Self.freeTierLimit
    }

    func add(_ entry: LitterEntry, isPro: Bool) -> Bool {
        guard canAdd(isPro: isPro) else { return false }
        entries.append(entry)
        return true
    }

    func remove(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }

    func update(_ entry: LitterEntry) {
        if let idx = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[idx] = entry
        }
    }

    private func seedIfNeeded() {
        if entries.isEmpty {
            entries = [Self.sampleSeed]
        }
    }

    private func persist() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(PersistedState(entries: entries)) {
            try? data.write(to: fileURL)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            seedIfNeeded()
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let state = try? decoder.decode(PersistedState.self, from: data) {
            self.entries = state.entries
            
        }
        seedIfNeeded()
    }

    struct PersistedState: Codable {
        var entries: [LitterEntry]
        
    }
    static let sampleSeed = LitterEntry(catName: "Whiskers", changed: true, bathroomCount: 2, date: Date(), notes: "")
}
