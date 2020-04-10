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
		XCTAssertEqual(try XCTUnwrap(prepareTestPact().payload["provider"] as? String), testProvider)
	}

	func testPact_SetsConsumer() throws {
		XCTAssertEqual(try XCTUnwrap(prepareTestPact().payload["consumer"] as? String), testConsumer)
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

		let expectedResult: [String: String] = ["Content-Type": "applicatoin/json; charset=UTF-8", "X-Value": "testCode"]
		let interaction = Interaction(
			description: "test_request_headers",
			providerStates: [
				ProviderState(
					name: "an alligator with the given name exists",
					params: ["name": "Mary"]
				),
				ProviderState(
					name: "the user is logged in",
					params: ["user": "Fred"]
				)
			],
			request: Request(
				method: .GET,
				path: "/",
				query: nil,
				headers: expectedResult,
				body: nil
			),
			response: Response(
				statusCode: 200,
				headers: nil
			)
		)

		let testPact = prepareTestPact(interactions: interaction)

		let testResult = try XCTUnwrap(((testPact.payload["interactions"] as? [Interaction])?.first)?.request.headers)
		XCTAssertEqual(testResult["Content-Type"], expectedResult["Content-Type"])
		XCTAssertEqual(testResult["X-Value"], expectedResult["X-Value"])
	}

	// MARK: - Interaction request query

	func testPact_SetsInteractionReqeustQuery() throws {
		let expectedResult = [
			"max_results": ["100"],
			"state": ["NSW"],
			"term": ["80 CLARENCE ST, SYDNEY NSW 2000"]
		]

		let interaction = Interaction(
			description: "test query dictionary",
			providerState: "some testable provider state",
			request: Request(
				method: .GET,
				path: "/autoComplete/address",
				query: expectedResult,
				headers: nil
			),
			response: Response(
				statusCode: 200,
				headers: nil
			)
		)

		let testPact = prepareTestPact(interactions: interaction)

		let testResult = try XCTUnwrap(((testPact.payload["interactions"] as? [Interaction])?.first)?.request.query)
		XCTAssertTrue(try (XCTUnwrap(testResult["max_results"]).contains("100")))
		XCTAssertTrue(try (XCTUnwrap(testResult["state"]).contains("NSW")))
		XCTAssertTrue(try (XCTUnwrap(testResult["term"]).contains("80 CLARENCE ST, SYDNEY NSW 2000")))
	}

	func testPact_SetsProviderState() throws {
		let expectedResult = "some testable provider state"

		let interaction = Interaction(
			description: "test provider state",
			providerState: expectedResult,
			request: Request(method: .GET, path: "/"),
			response: Response(statusCode: 200)
		)

		let testPact = prepareTestPact(interactions: interaction)

		let testResult = try XCTUnwrap(((testPact.payload["interactions"] as? [Interaction])?.first)?.providerState)
		XCTAssertEqual(testResult, expectedResult)
	}

	func testPact_SetsProviderStates() throws {
		let firstProviderState = ProviderState(name: "an alligator with the given name exists", params: ["name": "Mary"])
		let secondProviderState = ProviderState(name: "the user is logged in", params: ["username": "Fred"])
		let expectedResult = [firstProviderState, secondProviderState]

		let interaction = Interaction(
			description: "test provider states",
			providerStates: [
				ProviderState(name: "an alligator with the given name exists", params: ["name": "Mary"]),
				ProviderState(name: "the user is logged in", params: ["username": "Fred"])
			],
			request: Request(method: .GET, path: "/"),
			response: Response(statusCode: 200)
		)

		let testPact = prepareTestPact(interactions: interaction)
		let testResult = try XCTUnwrap(((testPact.payload["interactions"] as? [Interaction])?.first)?.providerStates)

		XCTAssertTrue(expectedResult.allSatisfy { expectedState in
			testResult.contains { $0 == expectedState }
		})
	}

	// MARK: - Interaction response

	func testPact_SetsInteractionResponseStatusCode() throws {
		let expectedResult = 201
		let interaction = prepareInteraction(description: "test_statusCode_interaction", statusCode: expectedResult)

		let testPact = prepareTestPact(interactions: interaction)

		let testResult = try XCTUnwrap((testPact.payload["interactions"] as? [Interaction])?.first).response.statusCode
		XCTAssertEqual(testResult, expectedResult)
	}

	// MARK: Encodable

	func testPact_SetsRequestBody() {
		let firstProviderState = ProviderState(name: "an alligator with the given name exists", params: ["name": "Mary"])
		let secondProviderState = ProviderState(name: "the user is logged in", params: ["username": "Fred"])

		let testBody: Any = [
			"foo": "Bar",
			"baz": 200.0,
			"bar": [
				"goo": 123.45
			],
			"fuu": ["xyz", "abc"],
			"num": [1, 2, 3]
		]

		let interaction = Interaction(
			description: "test Encodable Pact",
			providerStates: [firstProviderState, secondProviderState],
			request: Request(
				method: .GET,
				path: "/",
				query: ["max_results": ["100"]],
				headers: ["Content-Type": "applicatoin/json; charset=UTF-8", "X-Value": "testCode"],
				body: testBody
			),
			response: Response(
				statusCode: 200
			)
		)

		let testPact = Pact(
			consumer: Pacticipant.consumer("test-consumer"),
			provider: Pacticipant.provider("test-provider"),
			interactions: [interaction]
		)

		do {
			let testResult = try XCTUnwrap(try JSONDecoder().decode(TestPactModel.self, from: testPact.data!).interactions.first).request.body
			XCTAssertEqual(testResult.foo, "Bar")
			XCTAssertEqual(testResult.baz, 200.0)
			XCTAssertTrue(testResult.fuu.allSatisfy { ((testBody as! [String: Any])["fuu"] as! Array).contains($0) })
			XCTAssertTrue(testResult.num.allSatisfy { ((testBody as! [String: Any])["num"] as! Array).contains($0) })
			XCTAssertEqual(testResult.bar, ["goo": 123.45])
		} catch {
			XCTFail("Failed to decode `testModel.self` from `TestPact.data!`")
		}
	}

	func testPact_SetsRequestBody_MatchingRules() {
		let firstProviderState = ProviderState(name: "an alligator with the given name exists", params: ["name": "Mary"])

		let testBody: Any = [
			"foo": SomethingLike("Bar"),
			"baz": SomethingLike(200.0),
			"bar": [
				"goo": SomethingLike(123.45)
			],
			"fuu": ["xyz", SomethingLike("abc")],
			"data": [
				"array1": EachLike( // Doesn't like it as SomethingLike() isn't Encodable?
					[
						"dob": SomethingLike("2016-07-19"),
						"id": SomethingLike("1600309982"),
						"name": SomethingLike("FVsWAGZTFGPLhWjLuBOd")
					]
				),
//				"array1": [
//					[
//						"dob": SomethingLike("2016-07-19"),
//						"id": SomethingLike(1600309982),
//						"name": SomethingLike("FVsWAGZTFGPLhWjLuBOd")
//					]
//				],


// the `array1` should be wrapped in an EachLike([...], min: 1)
// but compiler complains - should do `$.data.array1[*].name` -> match Type
//				"array1": EachLike(
//					[
//						"dob": "2016-07-19",
//						"id": SomethingLike(1600309982),
//						"name": SomethingLike("FVsWAGZTFGPLhWjLuBOd")
//					]
//				, min: 1),
//
// And this should be the Pact matchingRules output (still need to figure out the [*]):
//				"$.data.array1": {
//						"matchers": [
//							{ "min": 1, "match": "type" }
//						]
//				},
//				"$.data.array1[*].name": {
//						 "matchers": [
//							 { "match": "type" }
//						 ]
//				 },
//				 "$.data.array1[*].id": {
//						 "matchers": [
//							 { "match": "type" }
//						 ]
//				 }


				"array2": [
					[
						"address": "127.0.0.1",
						"name": "jvxrzduZnwwxpFYrQnpd"
					]
				],
				"array3": [
					[
							[
									"itemCount": 652571349
							]
					]
				]
			],
			"num": EachLike(1, min: 2),
			"bool": [
				"false": SomethingLike(false),
				"true": SomethingLike(true)
			]
		]

//		let anotherBody: Any = [
//			EachLike([
//				"foo": SomethingLike("bar").value
//			])
//		]

		let interaction = Interaction(
			description: "test Encodable Pact",
			providerStates: [firstProviderState],
			request: Request(
				method: .GET,
				path: "/",
				query: ["max_results": ["100"]],
				headers: ["Content-Type": "applicatoin/json; charset=UTF-8", "X-Value": "testCode"],
				body: testBody
			),
			response: Response(
				statusCode: 200
			)
		)

		let testPact = Pact(
			consumer: Pacticipant.consumer("test-consumer"),
			provider: Pacticipant.provider("test-provider"),
			interactions: [interaction]
		)

		debugPrint(NSString(string: String(data: testPact.data!, encoding: .utf8)!))
		
	}

	func testPact_SetsRequestBody_EmbeddedMatchingRules() {
		let firstProviderState = ProviderState(name: "an alligator with the given name exists", params: ["name": "Mary"])

		let testBody: Any = [
			"data": [
				"array1": EachLike( // Doesn't like it as SomethingLike() isn't Encodable?
					[
						"dob": SomethingLike("2016-07-19"),
						"id": SomethingLike("1600309982"),
						"name": SomethingLike("FVsWAGZTFGPLhWjLuBOd")
					],
					min: 1
				)
			]
		]

		let interaction = Interaction(
			description: "test Encodable Pact",
			providerStates: [firstProviderState],
			request: Request(
				method: .GET,
				path: "/",
				query: ["max_results": ["100"]],
				headers: ["Content-Type": "applicatoin/json; charset=UTF-8", "X-Value": "testCode"],
				body: testBody
			),
			response: Response(
				statusCode: 200
			)
		)

		let testPact = Pact(
			consumer: Pacticipant.consumer("test-consumer"),
			provider: Pacticipant.provider("test-provider"),
			interactions: [interaction]
		)

		debugPrint(NSString(string: String(data: testPact.data!, encoding: .utf8)!))

	}

}


private extension PactTests {

	// MARK: - Test resources and definitions

	struct TestPactModel: Decodable {
		let interactions: [TestInteractionModel]

		struct TestInteractionModel: Decodable {
			let request: TestRequestModel

			struct TestRequestModel: Decodable {
				let body: TestBodyModel

				struct TestBodyModel: Decodable {
					let foo: String
					let baz: Double
					let bar: [String: Double]
					let fuu: [String]
					let num: [Int]
				}
			}

		}

	}

	// MARK: - Test Helper functions

	func prepareTestPact() -> Pact {
		Pact(consumer: Pacticipant.consumer(testConsumer), provider: Pacticipant.provider(testProvider))
	}

	func prepareTestPact(interactions: Interaction...) -> Pact {
		Pact(consumer: Pacticipant.consumer(testConsumer), provider: Pacticipant.provider(testProvider), interactions: interactions)
	}

	func prepareInteraction(description: String, method: PactHTTPMethod = .GET, path: String = "/", statusCode: Int = 200) -> Interaction {
		Interaction(
			description: description,
			providerState: "some testable provider state",
			request: Request(method: method, path: path),
			response: Response(statusCode: statusCode)
		)
	}

}
