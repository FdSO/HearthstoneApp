import XCTest

final class HearthstoneAppUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    func testExample() throws {
        let app = XCUIApplication()
        
        app.launch()
        
        let button = app.buttons.element(boundBy: 0)

        guard
            button.waitForExistence(timeout: 60.0),
            button.exists, button.isHittable
        else {
            return
        }
        
        button.tap()
        
        app.collectionViews.cells.element(boundBy: 2).tap()
        
        app.collectionViews.cells.element(boundBy: 5).tap()

        app.navigationBars.otherElements.element(boundBy: 0).tap()

        let element = app.cells.element(boundBy: 0)

        let startCoordinate = element.coordinate(withNormalizedOffset: .zero)
        let lastCoordinate = element.coordinate(withNormalizedOffset: .init(dx: 0, dy: 8))

        startCoordinate.press(
            forDuration: 0, thenDragTo: lastCoordinate
        )

        app.navigationBars.buttons.element(boundBy: 0).tap()

        app.buttons.element(boundBy: 1).tap()

        app.swipeUp(velocity: .fast)

        app.swipeDown(velocity: .fast)
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
