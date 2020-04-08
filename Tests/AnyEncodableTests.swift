//
//  AnyEncodableTests.swift
//  PactSwiftTests
//
//  Created by Marko Justinek on 7/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import XCTest

@testable import PactSwift

class AnyEncodableTests: XCTestCase {

	func testEncodableWrapper_Handles_StringValue() {
		do {
			let anyEncodedObject = try EncodableWrapper(for: ["Foo": "Bar"]).asEncodable()
			let testResult = try XCTUnwrap(String(data: try JSONEncoder().encode(try XCTUnwrap(anyEncodedObject, "Oh noez!")), encoding: .utf8))
			XCTAssertEqual(testResult, #"{"Foo":"Bar"}"#)
		} catch {
			XCTFail("Failed to unwrap or encode `anEncodedObject` into a `String`")
		}
	}

	func testEncodableWrapper_Handles_IntegerValue() {
		do {
			let anyEncodedObject = try EncodableWrapper(for: ["Foo": 123]).asEncodable()
			let testResult = try XCTUnwrap(String(data: try JSONEncoder().encode(try XCTUnwrap(anyEncodedObject, "Oh noez!")), encoding: .utf8))
			XCTAssertEqual(testResult, #"{"Foo":123}"#)
		} catch {
			XCTFail("Failed to unwrap or encode `anEncodedObject` into a `String`")
		}
	}

	func testEncodableWrapper_Handles_DoubleValue() {
		do {
			let anyEncodedObject = try EncodableWrapper(for: ["Foo": Double(123.45)]).asEncodable()
			let testResult = try XCTUnwrap(String(data: try JSONEncoder().encode(try XCTUnwrap(anyEncodedObject, "Oh noez!")), encoding: .utf8))
			XCTAssertEqual(testResult, #"{"Foo":123.45}"#)
		} catch {
			XCTFail("Failed to unwrap or encode `anEncodedObject` into a `String`")
		}
	}

	func testEncodableWrapper_Handles_DecimalValue() {
		do {
			let anyEncodedObject = try EncodableWrapper(for: ["Foo": Decimal(string: "123.45")]).asEncodable()
			let testResult = try XCTUnwrap(String(data: try JSONEncoder().encode(try XCTUnwrap(anyEncodedObject, "Oh noez!")), encoding: .utf8))
			XCTAssertEqual(testResult, #"{"Foo":123.45}"#)
		} catch {
			XCTFail("Failed to unwrap or encode `anEncodedObject` into a `String`")
		}
	}

	func testEncodableWrapper_Handles_BoolValue() {
		do {
			let anyEncodedObject = try EncodableWrapper(for: ["Foo": true]).asEncodable()
			let testResult = try XCTUnwrap(String(data: try JSONEncoder().encode(try XCTUnwrap(anyEncodedObject, "Oh noez!")), encoding: .utf8))
			XCTAssertEqual(testResult, #"{"Foo":true}"#)
		} catch {
			XCTFail("Failed to unwrap or encode `anEncodedObject` into a `String`")
		}
	}

	func testEncodableWrapper_Handles_ArrayOfStringsValue() {
		do {
			let anyEncodedObject = try EncodableWrapper(for: ["Foo": ["Bar", "Baz"]]).asEncodable()
			let testResult = try XCTUnwrap(String(data: try JSONEncoder().encode(try XCTUnwrap(anyEncodedObject, "Oh noez!")), encoding: .utf8))
			XCTAssertEqual(testResult, #"{"Foo":["Bar","Baz"]}"#)
		} catch {
			XCTFail("Failed to unwrap or encode `anEncodedObject` into a `String`")
		}
	}

	func testEncodableWrapper_Handles_ArrayOfDoublesValue() {
		do {
			let anyEncodedObject = try EncodableWrapper(for: ["Foo": [Double(123.45), Double(789.23)]]).asEncodable()
			let testResult = try XCTUnwrap(String(data: try JSONEncoder().encode(try XCTUnwrap(anyEncodedObject, "Oh noez!")), encoding: .utf8))
			XCTAssertTrue(testResult.contains("789.23")) // NOT THE RIGHT WAY TO TEST THIS! But it will do for now.
			XCTAssertTrue(testResult.contains(#"{"Foo":[123."#))
		} catch {
			XCTFail("Failed to unwrap or encode `anEncodedObject` into a `String`")
		}
	}

	func testEncodableWrapper_Handles_DictionaryValue() {
		do {
			let anyEncodedObject =  try EncodableWrapper(for: ["Foo": ["Bar": "Baz"]]).asEncodable()
			let testResult = try JSONEncoder().encode(try XCTUnwrap(anyEncodedObject, "Oh noez!"))
			XCTAssertEqual(String(data: testResult, encoding: .utf8), #"{"Foo":{"Bar":"Baz"}}"#)
		} catch {
			XCTFail("Failed to unwrap or encode `anEncodedObject` into a `String`")
		}
	}

	func testEncodableWrapper_Handles_EmbeddedSafeJSONValues() {
		do {
			let anyEncodedObject = try EncodableWrapper(
				for: [
					"Foo": 1,
					"Bar": 1.23,
					"Baz": ["Hello", "World"],
					"Goo": [
						"one": [1, 23.45],
						"two": true
					]
				]
			).asEncodable()

			let testResult = try XCTUnwrap(String(data: try JSONEncoder().encode(try XCTUnwrap(anyEncodedObject, "Oh noez!")), encoding: .utf8))

			// WARNING: - This is not the greatest way to test this! But it will do for now.
			// AnyEncodable `Request.body` is tested in `PactTests.swift` and handles this test on another level
			XCTAssertTrue(testResult.contains(#""Foo":1"#))
			XCTAssertTrue(testResult.contains(#""Bar":1.23"#))
			XCTAssertTrue(testResult.contains(#""Baz":["Hello","World"]"#))
			XCTAssertTrue(testResult.contains(#""Goo":{"#))
			XCTAssertTrue(testResult.contains(#""one":[1,23.4"#))
			XCTAssertTrue(testResult.contains(#""two":true"#))
		} catch {
			XCTFail("Failed to unwrap or encode `anEncodedObject` into a `String`")
		}
	}

}
