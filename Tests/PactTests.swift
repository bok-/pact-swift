//
//  PactTests.swift
//  PactSwiftTests
//
//  Created by Marko Justinek on 1/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import XCTest

@testable import PactSwift

class PactTests: XCTestCase {

	let testConsumer = "test_consumer"
	let testProvider = "test_provider"

	func testPact_SetsProvider() throws {
		XCTAssertEqual(try XCTUnwrap(prepareTestPact().payload["provider"] as? [String: String]), ["name": testProvider])
	}

	func testPact_SetsConsumer() throws {
		XCTAssertEqual(try XCTUnwrap(prepareTestPact().payload["consumer"] as? [String: String]), ["name": testConsumer])
	}

	func testPact_SetsMetadata() {
		XCTAssertNotNil(prepareTestPact().payload["metadata"])
	}

}

private extension PactTests {

	func prepareTestPact() -> Pact {
		Pact(consumer: Pacticipant.consumer(testConsumer), provider: Pacticipant.provider(testProvider))
	}

}
