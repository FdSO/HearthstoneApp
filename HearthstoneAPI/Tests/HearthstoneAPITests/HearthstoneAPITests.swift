import XCTest

@testable import HearthstoneAPI

final class HearthstoneAPITests: XCTestCase {
    func test_get_allCards() async throws {
        _ = try await HearthstoneGetAllCards(
            skipCardWithOutImage: true
        )
    }
}
