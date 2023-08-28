import XCTest
import HearthstoneAPI

final class CardListTests: XCTestCase {
    private final class MockInteractor: CardListInteractorProtocol {
        func fetchAllCards() async {
            let jsonText = """
                {
                  "dbfId": 56530,
                  "name": "Akama",
                  "cardSet": "Ashes of Outland"
                }
            """
            
            if let cards = try? JSONDecoder().decode(
                Card.self, from: .init(jsonText.utf8)
            ) {
                presenter.listState = .success([
                    .init(title: .init(), cards: [cards])
                ])
            } else {
                presenter.listState = .failure(.init())
            }
        }

        var presenter: CardListPresenterProtocol

        init(presenter: CardListPresenterProtocol) {
            self.presenter = presenter
        }
    }
    
    func test_feature_success() throws {
        let interactor = MockInteractor(
            presenter: CardListPresenter()
        )
        
        let expectation = XCTestExpectation()
        
        Task {
            await interactor.fetchAllCards()
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        switch interactor.presenter.listState {
            case let .success(allCards):
                let count = try XCTUnwrap(allCards.first?.cards.count)
            
                XCTAssertEqual(interactor.presenter.getCountText(count), "1 cards")
            default:
                XCTFail("error: \(interactor.presenter.listState.self)")
        }
    }
    
    func test_feature_failure() throws {
        let interactor = CardList.Mock.FailureInteractor(
            presenter: CardListPresenter()
        )
        
        let expectation = XCTestExpectation()

        Task {
            await interactor.fetchAllCards()
            
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
        
        if case .failure(_) = interactor.presenter.listState {} else {
            XCTFail("error: \(interactor.presenter.listState.self)")
        }
    }
}
