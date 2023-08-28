import HearthstoneAPI
import ArchitectureKit

protocol CardListPresenterProtocol: PresenterProtocol {
    var listState: UIState<AllCards> { get set }
    func getCountText(_ count: Int) -> String
}

struct CardListPresenter: CardListPresenterProtocol {
    var listState: UIState<AllCards> = .initial
    
    init() {}
    
    func getCountText(_ count: Int) -> String {
        "\(count) \(CardList.Text.cards)"
    }
}
