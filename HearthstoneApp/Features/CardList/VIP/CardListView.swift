import ArchitectureKit
import HearthstoneAPI
import SwiftUI

struct CardListView<Interactor: CardListInteractorProtocol>: ViewProtocol {
    @ObservedObject var interactor: Interactor
    
    var body: some View {
        NavigationView {
            VStack {
                switch interactor.presenter.listState {
                    case .initial:
                        LoadingView()

                    case let .success(allCards):
                        if allCards.isEmpty {
                            Text(CardList.Text.empty)
                        } else {
                            List(allCards, id: \.title) { cardSet in
                                Section {
                                    ForEach(cardSet.cards, id: \.dbfId) { card in
                                        NavigationLink(card.name) {
                                            CardDetail.Factory.createView(card)
                                        }
                                    }
                                } header: {
                                    Text(cardSet.title)
                                } footer: {
                                    Text(interactor.presenter.getCountText(cardSet.cards.count))
                                }
                            }
                        }
                    
                    case let .failure(message):
                        HStack {
                            Spacer()
                            VStack(spacing: 10) {
                                Text(message)
                                    .multilineTextAlignment(.center)
                                Button(CardList.Text.tryAgain) {
                                    Task {
                                        await interactor.fetchAllCards()
                                    }
                                }
                            }
                            Spacer()
                        }
                }
            }
            .navigationBarTitle(CardList.Text.navigation)
            .tasking {
                await interactor.fetchAllCards()
            }
        }
    }
}

struct CardListView_NormalPreview: PreviewProvider {
    static var previews: some View {
        CardList.Factory.createView()
    }
}

struct CardListView_EmptyPreview: PreviewProvider {
    static var previews: some View {
        CardListView(
            interactor: CardList.Mock.EmptyInteractor(presenter: CardListPresenter())
        )
    }
}

struct CardListView_FailurePreview: PreviewProvider {
    static var previews: some View {
        CardListView(
            interactor: CardList.Mock.FailureInteractor(presenter: CardListPresenter())
        )
    }
}


