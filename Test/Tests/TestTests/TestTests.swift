
import Combine
@testable import Test
import XCTest

class testNavigationTests: XCTestCase {

    private var flowSubject: PassthroughSubject<FlowAction, Never>!
    private var nav: UINavigationController!
    private var sut: FlowController!
    private var window: UIWindow!

    override func setUp() {
        flowSubject = PassthroughSubject<FlowAction, Never>()
        nav = UINavigationController()
        sut = FlowController(navigationController: nav, flowSubject: flowSubject)

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

    func test_TestViewController_lifeCycle() {

        XCTAssertNil(sut.navigation.presentedViewController)
        // given
        flowSubject.send(.didPost)

        // force extra run-loop cycle,
        RunLoop.current.run(until: Date())

        // expectation
        XCTAssert(sut.navigation.viewControllers.count == 1)
        print(sut.navigation.presentedViewController)
        XCTAssertTrue(sut.navigation.presentedViewController is TestViewController)

        // given

        flowSubject.send(.didDismiss)
        

        _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 10)
        print(sut.navigation.presentedViewController)

        //RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))

        //XCTAssert(sut.navigation.topViewController is ChildViewController)
        //XCTAssert(sut.navigation.viewControllers.count == 1)

        XCTAssertNil(nav.presentedViewController)
    }
}
