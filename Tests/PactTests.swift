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

	// MARK: - Interactions

	func testPact_SetsInteractionDescription() throws {
		let expectedResult = "test interaction"
		let interaction = prepareInteraction(description: expectedResult)

		let testPact = prepareTestPact(interactions: interaction)

		let testResult = try XCTUnwrap((testPact.payload["interactions"] as? [Interaction])?.first).description
		XCTAssertEqual(testResult, expectedResult)
	}

	// MARK: - Interaction request

	func testPact_SetsInteractionRequestMethod() throws {
		let expectedResult: PactHTTPMethod = .POST
		let interaction = prepareInteraction(description: "test_post_interaction", method: .POST)

		let testPact = prepareTestPact(interactions: interaction)

		let testResult = try XCTUnwrap((testPact.payload["interactions"] as? [Interaction])?.first).request.method
		XCTAssertEqual(testResult, expectedResult)
	}

	func testPact_SetsInteractionRequestPath() throws {
		let expectedResult = "/interactions"
		let interaction = prepareInteraction(description: "test_path_interaction", path: expectedResult)

		let testPact = prepareTestPact(interactions: interaction)

		let testResult = try XCTUnwrap((testPact.payload["interactions"] as? [Interaction])?.first).request.path
		XCTAssertEqual(testResult, expectedResult)
	}

	func testPact_SetsInteractionRequestHeaders() throws {
		let expectedResult: [String: String] = ["Content-Type": "applicatoin/json; charset=UTF-8"]
		let interaction = Interaction(
			description: "test_request_headers",
			request: Request(
				method: .GET,
				path: "/",
				query: nil,
				headers: expectedResult,
				body: nil
			),
			response: Response(
				statusCode: 200,
				headers: nil,
				body: nil
			)
		)

		let testPact = prepareTestPact(interactions: interaction)

		let testResult = try XCTUnwrap(((testPact.payload["interactions"] as? [Interaction])?.first)?.request.headers?["Content-Type"] as? String)
		XCTAssertEqual(testResult, expectedResult["Content-Type"])
	}

	// MARK: - Interaction response

	func testPact_SetsInteractionResponseStatusCode() throws {
		let expectedResult = 201
		let interaction = prepareInteraction(description: "test_statusCode_interaction", statusCode: expectedResult)

		let testPact = prepareTestPact(interactions: interaction)

		let testResult = try XCTUnwrap((testPact.payload["interactions"] as? [Interaction])?.first).response.statusCode
		XCTAssertEqual(testResult, expectedResult)
	}

}

private extension PactTests {

	func prepareTestPact() -> Pact {
		Pact(consumer: Pacticipant.consumer(testConsumer), provider: Pacticipant.provider(testProvider))
	}

	func prepareTestPact(interactions: Interaction...) -> Pact {
		Pact(consumer: Pacticipant.consumer(testConsumer), provider: Pacticipant.provider(testProvider), interactions: interactions)
	}

	func prepareInteraction(description: String, method: PactHTTPMethod = .GET, path: String = "/", statusCode: Int = 200) -> Interaction {
		Interaction(
			description: description,
			request: Request(method: method, path: path),
			response: Response(statusCode: statusCode)
		)
	}

}
