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
        XCTAssertNoThrow(try model.validateEmail("test.abc@example.com"), "Valid email should not throw")
        XCTAssertNoThrow(try model.validateEmail("test.abc@example-corp.com"), "Valid email should not throw")
        XCTAssertNoThrow(try model.validateEmail("test_abc@example-corp.com"), "Valid email should not throw")
        
        XCTAssertThrowsError(try model.validateEmail("invalid_email"), "Invalid email missing @ should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
        
        XCTAssertThrowsError(try model.validateEmail("invalid_email@a.a"), "Invalid email with only one domain character should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
        
        XCTAssertThrowsError(try model.validateEmail("invalid_email@a.ch."), "Invalid email with more than one dot should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
        
        XCTAssertThrowsError(try model.validateEmail("test..abcl@a.ch"), "Invalid email with double dot should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
        
        XCTAssertThrowsError(try model.validateEmail("testl@a-.ch"), "Invalid email with - at start or end of domain should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidEmail)
        }
        
        XCTAssertThrowsError(try model.validateEmail("testl@-a.ch"), "Invalid email with - at start or end of domain should throw") { error in
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
    
    func testValidateName() throws {
        let model = RegisterViewModel()
        
        XCTAssertNoThrow(try model.validateName("Max Mustermann"), "Valid name should not throw")
        
        XCTAssertThrowsError(try model.validateName(""), "Invalid empty name should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidName)
        }
    }
    
    func testValidateBirthday() throws {
        let model = RegisterViewModel()
        
        let validDate = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 1)) ?? Date.now
        XCTAssertNoThrow(try model.validateBirthday(validDate), "Valid date should not throw")
        
        XCTAssertThrowsError(try model.validateBirthday(Date.now), "Invalid date too close to now should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidBirthday)
        }
        
        XCTAssertThrowsError(try model.validateBirthday(Date.distantPast), "Invalid date too far in the past should throw") { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidBirthday)
        }
    }
    
    func testUserRegistration() throws {
        let ewgister = RegisterViewModel()
        let testStore = DefaultsStore(domain: "com.marcowenzel.SwiftUISample.test")
        ewgister.store = testStore
        
        let name = "Max Mustermann"
        let email = "max.mustermann@example.com"
        let calendar = Calendar.current
        let components = DateComponents(year: 1991, month: 1, day: 1)
        let bday = calendar.date(from: components)!
        
        XCTAssertNoThrow(try ewgister.validateName(name), "valid name should now throw")
        XCTAssertNoThrow(try ewgister.validateEmail(email), "valid mail should now throw")
        XCTAssertNoThrow(try ewgister.validateBirthday(bday), "valid bday should now throw")

        let user = User(name: name, email: email, birthday: bday)
        
        XCTAssertNoThrow(try ewgister.saveUser(user), "saving a valid user should not throw")
        
        let welcome = WelcomeViewModel()
        welcome.store = testStore
        
        let loadedUser = try welcome.fetchCurrentUser()
        XCTAssertEqual(loadedUser.name, name)
        XCTAssertEqual(loadedUser.email, email)
        XCTAssertEqual(loadedUser.birthday, bday)
        
        testStore.removeAll()
    }
    
    func testDefaultStore() throws {
        let store = DefaultsStore(domain: "com.marcowenzel.SwiftUISample.test")
        
        XCTAssertNoThrow(try store.set(true, forKey: "bool_test"), "saving should not fail")
        XCTAssertNoThrow(try store.set("hello", forKey: "string_test"), "saving should not fail")
        XCTAssertNoThrow(try store.set(123, forKey: "int_test"), "saving should not fail")
        XCTAssertNoThrow(try store.set(1.0, forKey: "double_test"), "saving should not fail")
        
        let loadedBool = try store.getBool(forKey: "bool_test")
        XCTAssert(loadedBool == true)
        
        let loadedString = try store.getString(forKey: "string_test")
        XCTAssert(loadedString == "hello")
        
        let loadedInt = try store.getInt(forKey: "int_test")
        XCTAssert(loadedInt == 123)
        
        let loadedDouble = try store.getDouble(forKey: "double_test")
        XCTAssert(loadedDouble == 1.0)
        
        store.removeAll()
    }
}
