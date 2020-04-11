//
//  PactBuilderTests.swift
//  PactSwiftTests
//
//  Created by Marko Justinek on 11/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import XCTest

@testable import PactSwift

class PactBuilderTests: XCTestCase {

	// MARK: - SomethingLike()

	func testPact_SetsMatcher_ForSomethingLike() {
		let testBody: Any = [
			"data":  SomethingLike("2016-07-19")
		]

		let testPact = prepareTestPact(for: testBody)

		do {
			let testResult = try XCTUnwrap(try XCTUnwrap(try JSONDecoder().decode(SomethingLikeTestModel.self, from: testPact.data!).interactions.first).request.matchingRules.body.node.matchers.first)
			XCTAssertEqual(testResult.match, "type")
		} catch {
			XCTFail("Failed to decode `testModel.self` from `TestPact.data!`")
		}

	}

	// MARK: - EachLike()

	func testPact_SetsDefaultMin_ForEachLikeMatcher() {
		let testBody: Any = [
			"data": [
				"array1": EachLike(
					[
						"dob": SomethingLike("2016-07-19"),
						"id": SomethingLike("1600309982"),
						"name": SomethingLike("FVsWAGZTFGPLhWjLuBOd")
					]
				)
			]
		]

		let testPact = prepareTestPact(for: testBody)

		do {
			let testResult = try XCTUnwrap(try XCTUnwrap(try JSONDecoder().decode(EachLikeTestModel.self, from: testPact.data!).interactions.first).request.matchingRules.body.node.matchers.first)
			XCTAssertEqual(testResult.min, 1)
			XCTAssertEqual(testResult.match, "type")
		} catch {
			XCTFail("Failed to decode `testModel.self` from `TestPact.data!`")
		}
	}

	func testPact_SetsProvidedMin_ForEachLikeMatcher() {
		let testBody: Any = [
			"data": [
				"array1": EachLike(
					[
						"dob": SomethingLike("2016-07-19"),
						"id": SomethingLike("1600309982"),
						"name": SomethingLike("FVsWAGZTFGPLhWjLuBOd")
					]
					, min: 3
				)
			]
		]

		let testPact = prepareTestPact(for: testBody)

		do {
			let testResult = try XCTUnwrap(try XCTUnwrap(try JSONDecoder().decode(EachLikeTestModel.self, from: testPact.data!).interactions.first).request.matchingRules.body.node.matchers.first)
			XCTAssertEqual(testResult.min, 3)
			XCTAssertEqual(testResult.match, "type")
		} catch {
			XCTFail("Failed to decode `testModel.self` from `TestPact.data!`")
		}
	}

	func testPact_SetsProvidedMax_ForEachLikeMatcher() {
		let testBody: Any = [
			"data": [
				"array1": EachLike(
					[
						"dob": SomethingLike("2016-07-19"),
						"id": SomethingLike("1600309982"),
						"name": SomethingLike("FVsWAGZTFGPLhWjLuBOd")
					]
					, max: 5
				)
			]
		]

		let testPact = prepareTestPact(for: testBody)

		do {
			let testResult = try XCTUnwrap(try XCTUnwrap(try JSONDecoder().decode(EachLikeTestModel.self, from: testPact.data!).interactions.first).request.matchingRules.body.node.matchers.first)
			XCTAssertEqual(testResult.max, 5)
			XCTAssertEqual(testResult.match, "type")
		} catch {
			XCTFail("Failed to decode `testModel.self` from `TestPact.data!`")
		}
	}

}

// MARK: - Private Utils -

private extension PactBuilderTests {

	// This model is tightly coupled with the SomethingLike Matcher
	struct SomethingLikeTestModel: Decodable {
		let interactions: [TestInteractionModel]
		struct TestInteractionModel: Decodable {
			let request: TestRequestModel
			struct TestRequestModel: Decodable {
				let matchingRules: TestMatchingRulesModel
				struct TestMatchingRulesModel: Decodable {
					let body: TestNodeModel
					struct TestNodeModel: Decodable {
						let node: TestMatchersModel
						enum CodingKeys: String, CodingKey {
							case node = "$.data"
						}
						struct TestMatchersModel: Decodable {
							let matchers: [TestTypeModel]
							struct TestTypeModel: Decodable {
								let match: String
							}
						}
					}
				}
			}
		}
	}

	// This model is tightly coupled for the EachLike Matcher
	struct EachLikeTestModel: Decodable {
		let interactions: [TestInteractionModel]
		struct TestInteractionModel: Decodable {
			let request: TestRequestModel
			struct TestRequestModel: Decodable {
				let matchingRules: TestMatchingRulesModel
				struct TestMatchingRulesModel: Decodable {
					let body: TestNodeModel
					struct TestNodeModel: Decodable {
						let node: TestMatchersModel
						enum CodingKeys: String, CodingKey {
							case node = "$.data.array1"
						}
						struct TestMatchersModel: Decodable {
							let matchers: [TestMinModel]
							struct TestMinModel: Decodable {
								let min: Int?
								let max: Int?
								let match: String
							}
						}
					}
				}
			}
		}
	}

	func prepareTestPact(for body: Any) -> Pact {
		let firstProviderState = ProviderState(name: "an alligator with the given name exists", params: ["name": "Mary"])

		let interaction = Interaction(
			description: "test Encodable Pact",
			providerStates: [firstProviderState],
			request: Request(
				method: .GET,
				path: "/",
				query: ["max_results": ["100"]],
				headers: ["Content-Type": "applicatoin/json; charset=UTF-8", "X-Value": "testCode"],
				body: body
			),
			response: Response(
				statusCode: 200
			)
		)

		return Pact(
			consumer: Pacticipant.consumer("test-consumer"),
			provider: Pacticipant.provider("test-provider"),
			interactions: [interaction]
		)
	}

}
