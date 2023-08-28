import SwiftUI

public enum UIState<T> {
    case initial, success(_ object: T), failure(_ text: String)
}

public protocol PresenterProtocol {}

public protocol InteractorProtocol: ObservableObject {
    associatedtype Presenter = PresenterProtocol
    
    var presenter: Presenter { get }
    
    init(presenter: Presenter)
}

open class Interactor<Presenter: PresenterProtocol>: InteractorProtocol {
    @Published public var presenter: Presenter

    public required init(presenter: Presenter) {
        self.presenter = presenter
    }
}

public protocol ViewProtocol: View {
    associatedtype Interactor = InteractorProtocol
    
    var interactor: Interactor { get }
    
    init(interactor: Interactor)
}
