//
//  EndpointTests.swift
//  namava-assesmentTests
//
//  Created by Vahid Ghanbarpour on 10/29/22.
//

import XCTest

class EndpointTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testURLRequest() throws {
        let endpointURL = URL.videoListItems
        let accountName = "rottingmummy"
        let endpointToken = "MbyKHQOPJggbujDR"
        XCTAssertEqual(endpointURL, URL(string: "https://v1.nocodeapi.com/\(accountName)/vimeo/\(endpointToken)/search"))
    }

    func testModelResource() throws {
        
        let query = "query"
        let page = "1"
        let perPage = "1"
        
        let resource = VideoList.resource(for: query, page: page, perPage: perPage)
        var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
        let queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: page),
            URLQueryItem(name: "perPage", value: perPage)
        ]
        components?.queryItems = queryItems
        let url = components?.url
        let request = URLRequest(url: url!)
        
        let accountName = "rottingmummy"
        let endpointToken = "MbyKHQOPJggbujDR"
        XCTAssertEqual(request.url, URL(string: "https://v1.nocodeapi.com/\(accountName)/vimeo/\(endpointToken)/search?q=query&page=1&perPage=1"))
    }
    
    func testAPICall() async throws {
        
        let query = "query"
        let page = "1"
        let perPage = "1"
        
        let resource = VideoList.resource(for: query, page: page, perPage: perPage)
        
        let result = try await Webservice().load(resource)
        
        switch result {
        case .success(let response):
            print(response)
        case .failure(_):
            assertionFailure()
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
