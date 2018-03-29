//
//  testTrack.swift
//  SampleProjectTests
//
//  Created by Saqib Khan on 3/29/18.
//  Copyright © 2018 Saqib Khan. All rights reserved.
//

import XCTest
import Alamofire

class testTrack: XCTestCase {
    
    var sessionUnderTest: URLSession!
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func testTheTrackURL()
    {
       
        let urlstring = "https://itunes.apple.com/search?term=jack+johnson&limit=10"
        let ituneURL = NSURL(string: urlstring)
        let urlRequest = URLRequest(url: ituneURL! as URL)
        
        let task = sessionUnderTest.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        task.resume()
    }
    
    
    func testDownloadClassMethodWithMethodURLAndDestination() {
        let urlString = "https://itunes.apple.com/search?term=jack+johnson&limit=10"
        
        let request = Alamofire.download(urlString)
        
        XCTAssertNotNil(request.request)
        XCTAssertEqual(request.request?.httpMethod, "GET")
        XCTAssertEqual(request.request?.url?.absoluteString, urlString)
    }
    
    
    func testJSONMapping() throws {
        

        guard let url =   Bundle.main.path(forResource: "rawData", ofType: "txt") else {
            XCTFail("Missing file: rawData.txt")
            return
        }
        do {
            let contents = try String(contentsOfFile: url)
            let data = contents.data(using: .utf8)!
            if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
            {
                if let array = json["results"] as? [Dictionary<String,String>]{
                    if let artistName = array[0]["artistName"]{
                         XCTAssertEqual(artistName, "Jack Johnson")
                    }
                    else{
                        XCTFail("Unable to match")
                    }
                    if let trackName = array[0]["trackName"]{
                        XCTAssertEqual(trackName, "Better Together")
                    }
                    else{
                        XCTFail("Unable to match")
                    }
                    
                    if let collectionName = array[0]["collectionName"]{
                        XCTAssertEqual(collectionName, "In Between Dreams")
                    }
                    else{
                        XCTFail("Unable to match")
                    }
                }
            } else {
                XCTFail("Unable to convert to json")
            }
            print(contents)
        } catch {
             XCTFail("Unable to convert")
            // contents could not be loaded
        }
//        let json = try Data(contentsOf: url)
//        do {
//            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
//            {
//                
//            } else {
//                print("bad json")
//            }
//        } catch let error as NSError {
//            print(error)
//        }
//        let user: Track =
//        XCTAssertEqual(user.name, "John")
//        XCTAssertEqual(user.age, 29)
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
