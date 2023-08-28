import HearthstoneAPI
import ArchitectureKit

protocol CardListInteractorProtocol: InteractorProtocol where Presenter == CardListPresenterProtocol {
    func fetchAllCards() async
}

final class CardListInteractor: CardListInteractorProtocol {
    @Published private(set) var presenter: CardListPresenterProtocol

    init(presenter: CardListPresenterProtocol) {
        self.presenter = presenter
    }

    @MainActor
    func fetchAllCards() async {
        if case .success(_) = presenter.listState {
            return
        }

        presenter.listState = .initial

        do {
            let allCards = try await HearthstoneGetAllCards(
                skipCardWithOutImage: false
            )

            presenter.listState = .success(allCards)
        } catch HearthstoneError.api(let message){
            presenter.listState = .failure(message)
        } catch {
            presenter.listState = .failure(
                error.localizedDescription
            )
        }
    }
}
