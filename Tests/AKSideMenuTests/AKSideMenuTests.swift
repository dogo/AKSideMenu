@testable import AKSideMenu
import UIKit
import XCTest

final class AKSideMenuTests: XCTestCase {
    func testSideMenuViewControllerFindsAncestor() {
        let rootViewController = UIViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        let sideMenu = AKSideMenu(contentViewController: navigationController,
                                  leftMenuViewController: UIViewController(),
                                  rightMenuViewController: nil)

        sideMenu.loadViewIfNeeded()

        XCTAssertIdentical(rootViewController.sideMenuViewController, sideMenu)
    }

    func testSetContentViewControllerWithoutAnimationReplacesChildController() {
        let initialContentViewController = UIViewController()
        let sideMenu = AKSideMenu(contentViewController: initialContentViewController,
                                  leftMenuViewController: nil,
                                  rightMenuViewController: nil)
        sideMenu.loadViewIfNeeded()

        let replacementViewController = UIViewController()
        sideMenu.setContentViewController(replacementViewController, animated: false)

        XCTAssertNil(initialContentViewController.parent)
        XCTAssertIdentical(replacementViewController.parent, sideMenu)
        XCTAssertIdentical(sideMenu.contentViewController, replacementViewController)
        XCTAssertNotNil(replacementViewController.view.superview)
    }

    func testReplacingMenuViewControllerUpdatesChildController() {
        let initialMenuViewController = UIViewController()
        let sideMenu = AKSideMenu(contentViewController: UIViewController(),
                                  leftMenuViewController: initialMenuViewController,
                                  rightMenuViewController: nil)
        sideMenu.loadViewIfNeeded()

        let replacementMenuViewController = UIViewController()
        sideMenu.leftMenuViewController = replacementMenuViewController

        XCTAssertNil(initialMenuViewController.parent)
        XCTAssertIdentical(replacementMenuViewController.parent, sideMenu)
        XCTAssertIdentical(sideMenu.leftMenuViewController, replacementMenuViewController)
        XCTAssertNotNil(replacementMenuViewController.view.superview)
    }

    static var allTests = [
        ("testSideMenuViewControllerFindsAncestor", testSideMenuViewControllerFindsAncestor),
        ("testSetContentViewControllerWithoutAnimationReplacesChildController", testSetContentViewControllerWithoutAnimationReplacesChildController),
        ("testReplacingMenuViewControllerUpdatesChildController", testReplacingMenuViewControllerUpdatesChildController),
    ]
}
