import ArchitectureKit
import HearthstoneAPI
import SwiftUI

enum CardList {
    enum Text {
        static let navigation = "All Cards"
        static let cards = "cards"
        static let empty = "Empty List"
        static let tryAgain = "Try Again"
    }
    
    enum Mock {
        final class EmptyInteractor: CardListInteractorProtocol {
            func fetchAllCards() async {
                presenter.listState = .success(.init())
            }

            @Published var presenter: CardListPresenterProtocol

            init(presenter: CardListPresenterProtocol) {
                self.presenter = presenter
            }
        }
        
        final class FailureInteractor: CardListInteractorProtocol {
            func fetchAllCards() async {
                presenter.listState = .failure("Server Down")
            }

            @Published var presenter: CardListPresenterProtocol

            init(presenter: CardListPresenterProtocol) {
                self.presenter = presenter
            }
        }
    }
    
    enum Factory {
        static func createView() -> some View {
            let presenter = CardListPresenter()
            
            let interactor = CardListInteractor(
                presenter: presenter
            )
            
            let view = CardListView(
                interactor: interactor
            )
            
            return view
        }
    }
}
