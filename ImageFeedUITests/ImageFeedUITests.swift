//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Mikhail Eliseev on 20.11.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let appLogin = "" // <---- login
    private let appPassword = "" // <---- pass
    let username = "" // <---- user name
    let nickname = "@" // <---- @nickname
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments = ["testMode"]
        app.launch()
    }
    
    func testAuth() throws {
        let button = app.buttons["Authenticate"]
        XCTAssertTrue(button.waitForExistence(timeout: 5))
        button.tap()

        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        
        loginTextField.tap()
        loginTextField.typeText(appLogin)
        
        webView.swipeUp()

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(appPassword)
        
        webView.swipeUp()

        webView.buttons["Login"].tap()

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tableView = app.tables
        
        let cell = tableView.descendants(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(5)
        
        let cellToLike = tableView.descendants(matching: .cell).element(boundBy: 1)
        let likeButton = cellToLike.buttons["likeButton"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 10))
        
        likeButton.tap()
        likeButton.tap()
        sleep(5)
        
        cellToLike.tap()
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButton = app.buttons["navBackButton"]
        navBackButton.tap()
    }
    
    func testProfile() throws {
        sleep(2)

        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts[username].exists)
        XCTAssertTrue(app.staticTexts[nickname].exists)

        app.buttons["logoutButton"].tap()
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        sleep(3)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}
