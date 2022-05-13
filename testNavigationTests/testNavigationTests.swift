//
//  testNavigationTests.swift
//  testNavigationTests
//
//  Created by Justin on 2022-05-11.
//

import Combine
import CombineSchedulers
import SnapshotTesting
@testable import Test
import XCTest
import Nimble

class testNavigationTests: XCTestCase {

    private var flowSubject: PassthroughSubject<FlowAction, Never>!
    private var nav: UINavigationController!
    private var sut: FlowController!
    private var window: UIWindow!

    override func setUp() {
        UIView.setAnimationsEnabled(false)
        flowSubject = PassthroughSubject<FlowAction, Never>()
        nav = UINavigationController()
        sut = FlowController(navigationController: nav, flowSubject: flowSubject)
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = sut

        super.setUp()
    }

    override func tearDown() {
        UIView.setAnimationsEnabled(true)
        flowSubject = nil
        nav = nil
        sut = nil
        window = nil
        super.tearDown()
    }

    func test_ChildViewController_is_initial_controller() {

        XCTAssertNotNil(sut.navigation.topViewController)
        XCTAssert(sut.navigation.topViewController is ChildViewController)
        XCTAssert(sut.navigation.viewControllers.count == 1)
    }

    func test_TestViewController_lifeCycle() {

        // given
        flowSubject.send(.didPost)

        // expectation
        XCTAssert(sut.navigation.viewControllers.count == 1)
        XCTAssertTrue(sut.navigation.presentedViewController is TestViewController)

        // given
        flowSubject.send(.didDismiss)

        // expectation
        XCTAssert(sut.navigation.topViewController is ChildViewController)
        XCTAssert(sut.navigation.viewControllers.count == 1)
        expect(self.sut.navigation.presentedViewController).toEventually(beNil())
    }

    func test1_TestViewController_lifeCycle() {

        // given
        flowSubject.send(.didPost)

        // expectation
        XCTAssert(sut.navigation.viewControllers.count == 1)
        XCTAssertTrue(sut.navigation.presentedViewController is TestViewController)

        // given
        flowSubject.send(.didDismiss)

        // expectation
        XCTAssert(sut.navigation.topViewController is ChildViewController)
        XCTAssert(sut.navigation.viewControllers.count == 1)
        expect(self.sut.navigation.presentedViewController).toEventually(beNil())
    }

    func test2_TestViewController_lifeCycle() {

        // given
        flowSubject.send(.didPost)

        // expectation
        XCTAssert(sut.navigation.viewControllers.count == 1)
        XCTAssertTrue(sut.navigation.presentedViewController is TestViewController)

        // given
        flowSubject.send(.didDismiss)

        // expectation
        XCTAssert(sut.navigation.topViewController is ChildViewController)
        XCTAssert(sut.navigation.viewControllers.count == 1)
        expect(self.sut.navigation.presentedViewController).toEventually(beNil())
    }


    func test3_TestViewController_lifeCycle() {

        // given
        flowSubject.send(.didPost)

        // expectation
        XCTAssert(sut.navigation.viewControllers.count == 1)
        XCTAssertTrue(sut.navigation.presentedViewController is TestViewController)

        // given
        flowSubject.send(.didDismiss)

        // expectation
        XCTAssert(sut.navigation.topViewController is ChildViewController)
        XCTAssert(sut.navigation.viewControllers.count == 1)
        expect(self.sut.navigation.presentedViewController).toEventually(beNil(), timeout: .seconds(1))
    }
}
