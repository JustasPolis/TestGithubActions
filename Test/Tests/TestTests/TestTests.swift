
import Combine
@testable import Test
import XCTest

class TestNavigationTests: XCTestCase {

    private var flowSubject: PassthroughSubject<FlowAction, Never>!
    private var nav: UINavigationController!
    private var sut: FlowController!
    private var window: UIWindow!
    // sdsadssddddasdadadadadsadsaqweqweqweqweqeqeqwweqeqeqeqeqeqwewqeqwweqeqweqeqwweqwweqweqeqwweqeqewqeqwwewqeqweqweqwewqeqwewqeeq
    override func setUp() {
        flowSubject = PassthroughSubject<FlowAction, Never>()
        nav = UINavigationController()
        sut = FlowController(
            navigationController: nav,
            flowSubject: flowSubject
        )

        UIView.setAnimationsEnabled(false)
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = sut

        nav.loadViewIfNeeded()
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        flowSubject = nil
        nav = nil
        sut = nil
        window = nil
    }

    func test_ChildViewController_is_initial_controller() {

        XCTAssertNotNil(sut.navigation.topViewController)
        XCTAssert(sut.navigation.topViewController is ChildViewController)
        XCTAssert(sut.navigation.viewControllers.count == 1)
    }
}
