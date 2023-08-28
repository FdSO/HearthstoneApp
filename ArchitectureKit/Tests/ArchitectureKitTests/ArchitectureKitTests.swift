import XCTest
import SwiftUI

@testable import ArchitectureKit

final class ArchitectureKitTests: XCTestCase {
    private struct MockPresenter: PresenterProtocol, Equatable {}
    
    private final class MockInteractor: InteractorProtocol {
        var presenter: MockPresenter
        
        init(presenter: MockPresenter) {
            self.presenter = presenter
        }
    }
    
    private struct MockView: ViewProtocol {
        var interactor: MockInteractor

        init(interactor: MockInteractor) {
            self.interactor = interactor
        }

        var body: some View {
            Spacer()
        }
    }
    
    func test_presenter_dependency_injection() {
        let presenter = MockPresenter()
        let interactor = MockInteractor(presenter: presenter)
        
        XCTAssertEqual(interactor.presenter, presenter)
    }
        
    func test_interactor_dependency_injection() {
        let presenter = MockPresenter()
        let interactor = MockInteractor(presenter: presenter)
        let view = MockView(interactor: interactor)

        XCTAssertIdentical(view.interactor, interactor)
    }
}
