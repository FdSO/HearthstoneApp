import Foundation

public struct Card: Decodable {
    public enum Rarity: String, Decodable {
        case Free
        case Common
        case Rare
        case Epic
        case Legendary
    }
    
    public let dbfId: Int
    public let img: URL?
    public let name: String
    public let flavor: String?
    public let text: String?
    public let cardSet: String
    public let type: String?
    public let faction: String?
    public let rarity: Rarity?
    public let attack: UInt16?
    public let cost: UInt8?
    public let health: UInt16?
}

public struct CardSet {
    public let title: String
    public let cards: [Card]
    
    public init(title: String, cards: [Card]) {
        self.title = title
        self.cards = cards
    }
}

public typealias AllCards = [CardSet]

fileprivate struct AllCardsResponse: Decodable {
    private struct DynamicCodingKey: CodingKey {
        var stringValue: String

        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) { nil }
    }

    fileprivate let allCards: AllCards

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)

        let sortedKeys = container.allKeys.sorted { $0.stringValue < $1.stringValue }

        self.allCards = try sortedKeys.map {
            .init(title: $0.stringValue, cards: try container.decode([Card].self, forKey: $0))
        }
    }
}

public func HearthstoneGetAllCards(skipCardWithOutImage: Bool) async throws -> AllCards {
    let response: AllCardsResponse = try await execute("cards")

    return response.allCards.compactMap { cardSet in
        let cards = {
            if skipCardWithOutImage {
                return cardSet.cards.filter { $0.img != nil }
            }
            
            return cardSet.cards
        }()
        
        return .init(
            title: cardSet.title, cards: cards.sorted { $0.name < $1.name }
        )
    }
}
