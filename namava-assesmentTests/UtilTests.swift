//
//  UtilTests.swift
//  namava-assesmentTests
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import XCTest

class UtilTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTimeFormatter() throws {
        let timeInSeconds = 414
        let formattedTime = TimeFormatter().getTimeFormat(off: timeInSeconds)
        
        XCTAssertEqual(formattedTime, "06:54")
    }

    func testSecretreader() throws {
        
        XCTAssertNotNil(SecretReader.accountName)
        XCTAssertNotNil(SecretReader.clientSecret)
        XCTAssertNotNil(SecretReader.clientIdentifier)
        XCTAssertNotNil(SecretReader.endpointToken)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
