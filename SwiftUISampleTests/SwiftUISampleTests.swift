//
//  SwiftUISampleTests.swift
//  SwiftUISampleTests
//
//  Created by Marco Wenzel on 08/03/2024.
//

import XCTest

final class SwiftUISampleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidateEmail() throws {
        let model = RegisterViewModel()
        
        XCTAssertNoThrow(try model.validateEmail("test@example.com"), "Valid email should not throw")
        
        XCTAssertThrowsError(try model.validateEmail("invalid_email"), "Invalid email missing @ should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
        
        XCTAssertThrowsError(try model.validateEmail("invalid_email@a.a"), "Invalid email with only one domain character should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
        
        XCTAssertThrowsError(try model.validateEmail("invalid_email@a.ch."), "Invalid email with more than one dot should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
        
        XCTAssertThrowsError(try model.validateEmail("invalid_email@@a.ch"), "Invalid email with more than @ should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
        
        XCTAssertThrowsError(try model.validateEmail("test@.ch"), "Invalid email missing domain part should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
        
        XCTAssertThrowsError(try model.validateEmail("@a.ch"), "Invalid email missing local part should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
        
        XCTAssertThrowsError(try model.validateEmail("äüo@a.ch"), "Invalid email with non supported letters should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
        
        XCTAssertThrowsError(try model.validateEmail("%$@a.ch"), "Invalid email with non supported chars should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
        
        XCTAssertThrowsError(try model.validateEmail(""), "Empty email should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
    }
}
