import XCTest
import HearthstoneAPI

final class CardDetailTests: XCTestCase {
    func test_feature_with_image() throws {
        let jsonText = """
            {
              "dbfId": 56530,
              "name": "Akama",
              "cardSet": "Ashes of Outland",
              "img": "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/1e768afcb6eddf2c4ae09a336fcdc9973d92033566b10067f9eacb0b9738e8c8.png"
            }
        """

        let card = try JSONDecoder().decode(
            Card.self, from: .init(jsonText.utf8)
        )

        let interactor = CardDetailInteractor(
            presenter: CardDetailPresenter(card: card)
        )

        let expectation = XCTestExpectation()

        Task {
            await interactor.fetchImageCard()

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)

        if case .success(_) = interactor.presenter.imageState {} else {
            XCTFail("error: \(interactor.presenter.imageState.self)")
        }
    }
    
    func test_feature_without_image() throws {
        let jsonText = """
            {
              "dbfId": 56530,
              "name": "Akama",
              "cardSet": "Ashes of Outland",
              "img": "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/1e768afcb6eddf2c4ae09a336fcdc9973d92033566b10067f9eacb0b9738e8c8x.png"
            }
        """

        let card = try JSONDecoder().decode(
            Card.self, from: .init(jsonText.utf8)
        )

        let interactor = CardDetailInteractor(
            presenter: CardDetailPresenter(card: card)
        )

        let expectation = XCTestExpectation()

        Task {
            await interactor.fetchImageCard()

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)

        if case .failure(_) = interactor.presenter.imageState {} else {
            XCTFail("error: \(interactor.presenter.imageState.self)")
        }
    }
}
