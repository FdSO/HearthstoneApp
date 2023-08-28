import HearthstoneAPI
import ArchitectureKit
import SwiftUI

protocol CardDetailInteractorProtocol: InteractorProtocol where Presenter == CardDetailPresenterProtocol {
    func fetchImageCard() async
}

final class CardDetailInteractor: CardDetailInteractorProtocol {
    @Published private(set) var presenter: CardDetailPresenterProtocol

    init(presenter: CardDetailPresenterProtocol) {
        self.presenter = presenter
    }

    @MainActor
    func fetchImageCard() async {
        guard let url = presenter.img else { return }
        
        presenter.imageState = .initial
        
        let image = UIImage(
            data: (try? await HearthstoneGetData(url: url)) ?? .init()
        )
    
        if let image {
            presenter.imageState = .success(image)
        } else {
            presenter.imageState = .failure(
                CardDetail.Text.imageError
            )
        }
    }
}
