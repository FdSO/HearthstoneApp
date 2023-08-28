import HearthstoneAPI
import ArchitectureKit
import SwiftUI

struct CardDetailView<Interactor: CardDetailInteractorProtocol>: ViewProtocol {
    @ObservedObject var interactor: Interactor
    
    @State private var webViewHeight = CGFloat()
    @State private var showingInfos = false
    
    var infoView: some View {
        Group {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text(interactor.presenter.name)
                        .font(.largeTitle)
                    Spacer()
                }
                
                if let string = interactor.presenter.text {
                    HTMLText(.center, string: string)
                        
                }
            }
            Section {
                Text(interactor.presenter.rarityName)
                    .foregroundColor(interactor.presenter.rarityColor)
                    .bold()
            } header: {
                Text(CardDetail.Text.rarity)
            }
            Section {
                HStack {
                    Text(CardDetail.Text.type)
                    Spacer()
                    Text(interactor.presenter.type)
                        .font(.caption)
                }
                HStack {
                    Text(CardDetail.Text.faction)
                    Spacer()
                    Text(interactor.presenter.faction)
                        .font(.caption)
                }
            }
            Section {
                HStack {
                    Text(CardDetail.Text.cost)
                    Spacer()
                    Text(interactor.presenter.cost)
                        .foregroundColor(.blue)
                        .bold()
                }
                
                HStack {
                    Text(CardDetail.Text.attack)
                    Spacer()
                    Text(interactor.presenter.attack)
                        .foregroundColor(.yellow)
                        .bold()
                }
                HStack {
                    Text(CardDetail.Text.health)
                    Spacer()
                    Text(interactor.presenter.health)
                        .foregroundColor(.red)
                        .bold()
                }
            }
        }
    }
    
    var body: some View {
        List {
            if interactor.presenter.img != nil {
                switch interactor.presenter.imageState {
                    case .initial:
                        HStack {
                            Spacer()
                            LoadingView()
                            Spacer()
                        }
                    
                    case let .success(image):
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .offset(x: 8, y: -8)
                    
                    case let .failure(message):
                        HStack {
                            Spacer()
                            VStack(spacing: 10) {
                                Text(message)
                                    .multilineTextAlignment(.center)
                                Button(CardList.Text.tryAgain) {
                                    Task {
                                        await interactor.fetchImageCard()
                                    }
                                }
                            }
                            Spacer()
                        }
                }
            } else {
                infoView
            }
            if let flavor = interactor.presenter.flavor {
                Section {
                    HStack {
                        Spacer()
                        Text(flavor)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            }
            Section {
                HStack {
                    Spacer()
                    Text(interactor.presenter.cardSet)
                        .bold()
                    Spacer()
                }
            }
        }
        .listStyle(.grouped)
        .navigationBarTitle(
            Text(CardDetail.Text.navigation), displayMode: .inline
        )
        .navigationBarItems(trailing:
            Button(action: {
                showingInfos.toggle()
            }, label: {
                Image(systemName: CardDetail.Image.info)
            })
                .disabled(interactor.presenter.img == nil)
        )
        .sheet(isPresented: $showingInfos) {
            List {
                infoView
            }
            .listStyle(.grouped)
        }
        .tasking {
            await interactor.fetchImageCard()
        }
    }
}

struct CardDetailView_NormalPreviews: PreviewProvider {
    static var card: Card? {
        let jsonText = """
            {
              "dbfId": 56530,
              "name": "Akama",
              "cardSet": "Ashes of Outland",
              "img": "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/1e768afcb6eddf2c4ae09a336fcdc9973d92033566b10067f9eacb0b9738e8c8.png"
            }
        """

        return try? JSONDecoder().decode(
            Card.self, from: .init(jsonText.utf8)
        )
    }
    
    static var previews: some View {
        NavigationView {
            if let card {
                CardDetail.Factory.createView(card)
            }
        }
    }
}

struct CardDetailView_EmptyPreviews: PreviewProvider {
    static var card: Card? {
        let jsonText = """
            {
              "dbfId": 56530,
              "name": "Akama",
              "cardSet": "Ashes of Outland"
            }
        """

        return try? JSONDecoder().decode(
            Card.self, from: .init(jsonText.utf8)
        )
    }
    
    static var previews: some View {
        NavigationView {
            if let card {
                CardDetail.Factory.createView(card)
            }
        }
    }
}

struct CardDetailView_FailurePreviews: PreviewProvider {
    static var card: Card? {
        let jsonText = """
            {
              "dbfId": 56530,
              "name": "Akama",
              "cardSet": "Ashes of Outland",
              "img": "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/1e768afcb6eddf2c4ae09a336fcdc9973d92033566b10067f9eacb0b9738e8c8x.png"
            }
        """

        return try? JSONDecoder().decode(
            Card.self, from: .init(jsonText.utf8)
        )
    }
    
    static var previews: some View {
        NavigationView {
            if let card {
                CardDetail.Factory.createView(card)
            }
        }
    }
}
