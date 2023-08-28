import HearthstoneAPI
import ArchitectureKit
import SwiftUI

protocol CardDetailPresenterProtocol: PresenterProtocol {
    var imageState: UIState<UIImage> { get set }
    var img: URL? { get }
    var text: String? { get }
    var cardSet: String { get }
    var name: String { get }
    var flavor: String? { get }
    var rarityName: String { get }
    var rarityColor: Color? { get }
    var type: String { get }
    var faction: String { get }
    var cost: String { get }
    var attack: String { get }
    var health: String { get }
}

struct CardDetailPresenter: CardDetailPresenterProtocol {
    var imageState: UIState<UIImage> = .initial
    
    private let card: Card

    init(card: Card) {
        self.card = card
    }

    var img: URL? {
        card.img
    }

    var text: String? {
        if let text = card.text {
            var string = text

            string = string.replacingOccurrences(of: "_", with: " ")
            string = string.replacingOccurrences(of: "[x]", with: "")
            string = string.replacingOccurrences(of: "$", with: "")

            return string
        }

        return nil
    }

    var cardSet: String {
        card.cardSet
    }

    var name: String {
        card.name
    }

    var flavor: String? {
        card.flavor
    }

    var rarityName: String {
        card.rarity?.rawValue ?? CardDetail.Text.unknown
    }

    var rarityColor: Color? {
        switch card.rarity {
            case .Common:       return .gray
            case .Rare:         return .blue
            case .Epic:         return .purple
            case .Legendary:    return .orange
            default:            return nil
        }
    }

    var type: String {
        card.type ?? CardDetail.Text.unknown
    }

    var faction: String {
        card.faction ?? CardDetail.Text.none
    }

    var cost: String {
        if let cost = card.cost {
            return "\(cost)"
        }

        return CardDetail.Text.empty
    }

    var attack: String {
        if let attack = card.attack {
            return "\(attack)"
        }

        return CardDetail.Text.empty
    }

    var health: String {
        if let health = card.health {
            return "\(health)"
        }

        return CardDetail.Text.empty
    }
}
