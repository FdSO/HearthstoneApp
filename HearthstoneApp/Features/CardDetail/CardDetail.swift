import HearthstoneAPI
import SwiftUI

enum CardDetail {
    enum Text {
        static let navigation = "Card Detail"
        static let rarity = "Rarity"
        static let type = "Type"
        static let unknown = "Unknown"
        static let none = "None"
        static let faction = "Faction"
        static let cost = "Cost"
        static let attack = "Attack"
        static let health = "Health"
        static let empty = "-"
        static let imageError = "Image Error"
        static let tryAgain = "Try Again"
    }

    enum Image {
        static let info = "info.circle"
    }

    enum Factory {
        static func createView(_ card: Card) -> some View {
            let presenter = CardDetailPresenter(card: card)
            
            let interactor = CardDetailInteractor(
                presenter: presenter)

            let view = CardDetailView(interactor: interactor)

            return view
        }
    }
}
