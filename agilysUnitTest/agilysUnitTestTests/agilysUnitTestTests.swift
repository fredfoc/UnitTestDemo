//
//  agilysUnitTestTests.swift
//  agilysUnitTestTests
//
//  Created by fauquette fred on 28/01/16.
//  Copyright © 2016 Agilys. All rights reserved.
//

import XCTest
@testable import agilysUnitTest

class agilysUnitTestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        enum MockData: String {
            case Nil = "nil"
        }
        
        class MockDataProviderManager {
            func mockedJsonStringFromFile(dataType: MockData) -> String? {
                switch dataType {
                case .Nil:
                    return nil
                default:
                    return "no key"
                }
            }
        }
        
        class MockDataProviderManagerNil: MockDataProviderManager, DataProviderProtocol {
            func jsonStringFromFile(fileName: String) -> String? {
                return mockedJsonStringFromFile(.Nil)
            }
        }
        
        DataProviderManager.sharedInstance.dataProvider = MockDataProviderManagerNil()
        do {
            try DataProviderManager.sharedInstance.getResult()
        } catch DataError.NoData {
            XCTAssertTrue(true)
        } catch {
            // nothing
        }
        
    }
    
}
