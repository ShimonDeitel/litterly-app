import XCTest
@testable import Litterly

final class LitterlyTests: XCTestCase {
    var store: LitterlyStore!

    override func setUp() {
        super.setUp()
        store = LitterlyStore()
    }

    func testSeedDataIsBelowFreeLimit() {
        XCTAssertLessThan(store.entries.count, LitterlyStore.freeTierLimit)
    }

    func testAddIncreasesCount() {
        let before = store.entries.count
        let added = store.add(LitterEntry(catName: "C", changed: true, bathroomCount: 1), isPro: false)
        XCTAssertTrue(added)
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testAddRespectsFreeLimitWhenNotPro() {
        while store.entries.count < LitterlyStore.freeTierLimit {
            _ = store.add(LitterEntry(catName: "C", changed: true, bathroomCount: 1), isPro: false)
        }
        let blocked = store.add(LitterEntry(catName: "C", changed: true, bathroomCount: 1), isPro: false)
        XCTAssertFalse(blocked)
    }

    func testProBypassesFreeLimit() {
        while store.entries.count < LitterlyStore.freeTierLimit {
            _ = store.add(LitterEntry(catName: "C", changed: true, bathroomCount: 1), isPro: false)
        }
        let allowed = store.add(LitterEntry(catName: "C", changed: true, bathroomCount: 1), isPro: true)
        XCTAssertTrue(allowed)
    }

    func testCanAddReflectsLimit() {
        while store.entries.count < LitterlyStore.freeTierLimit {
            _ = store.add(LitterEntry(catName: "C", changed: true, bathroomCount: 1), isPro: false)
        }
        XCTAssertFalse(store.canAdd(isPro: false))
        XCTAssertTrue(store.canAdd(isPro: true))
    }

    func testRemoveDecreasesCount() {
        _ = store.add(LitterEntry(catName: "C", changed: true, bathroomCount: 1), isPro: false)
        let before = store.entries.count
        store.remove(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, before - 1)
    }

    func testIsAtFreeLimitFalseInitially() {
        XCTAssertFalse(store.isAtFreeLimit)
    }

    func testPersistedStateRoundTrips() {
        let count = store.entries.count
        let reloaded = LitterlyStore()
        XCTAssertEqual(reloaded.entries.count, count)
    }
}
