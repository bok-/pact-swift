//
//  EncodableWrapper.swift
//  PactSwift
//
//  Created by Marko Justinek on 7/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

struct PactEncodable {

	let typeDefinition: Any

	init(value: Any) {
		self.typeDefinition = value
	}

	/// Returns a tuple of a Pact Contract interaction's node object (eg, request `body`)
	/// and its corresponding matching rules.
	/// It erases node object's type and casts the node and leaf values into an `Encodable` safe type.
	///
	/// Transforms the following suppoerted types into `AnyEncodable`:
	///
	/// - `String`
	/// - `Int`
	/// - `Double`
	/// - `Array<Encodable>`
	/// - `Dictionary<String, Encodable>`
	///
	func encoded() throws -> (node: AnyEncodable?, rules: AnyEncodable?) {
		do {
			let processedType = try process(element: typeDefinition, at: "$")
			return (node: processedType.node, rules: processedType.rules)
		} catch {
			throw EncodingError.notEncodable(typeDefinition)
		}
	}

}

extension PactEncodable {

	enum EncodingError: Error {
		case notEncodable(Any?)
		case unknown

		var localizedDescription: String {

			switch self {
			case .notEncodable(let element):
				return "Error casting '\(String(describing: (element != nil) ? element! : "provided value"))' to a JSON safe Type: String, Int, Double, Decimal, Bool, Dictionary<String, Encodable>, Array<Encodable>)" //swiftlint:disable:this line_length
			default:
				return "Error casting unknown type into an Encodable type!"
			}
		}
	}

}

private extension PactEncodable {

	func process(element: Any, at node: String) throws -> (node: AnyEncodable?, rules: AnyEncodable?) {
		let processedElement: (node: AnyEncodable?, rules: AnyEncodable?)

		switch element {
		case let array as [Any]:
			let processedArray = try process(array, at: node)
			processedElement = (node: AnyEncodable(processedArray.node), rules: AnyEncodable(processedArray.rules))
		case let dict as [String: Any]:
			let processedDict = try process(dict, at: node)
			processedElement = (node: AnyEncodable(processedDict.node), rules: AnyEncodable(processedDict.rules))
		case let string as String:
			processedElement = (node: AnyEncodable(string), rules: nil)
		case let integer as Int:
			processedElement = (node: AnyEncodable(integer), rules: nil)
		case let double as Double:
			processedElement = (node: AnyEncodable(double), rules: nil)
		case let decimal as Decimal:
			processedElement = (node: AnyEncodable(decimal), rules: nil)
		case let bool as Bool:
			processedElement = (node: AnyEncodable(bool), rules: nil)
		case let matcher as MatchingRuleExpressible:
			processedElement = (
				node: AnyEncodable(Matcher(matcher)?.value),
				rules: AnyEncodable([node: ["matchers": [matcher.rule]]])
			)
		default:
			throw EncodingError.notEncodable(element)
		}

		return processedElement
	}

	func process(_ array: [Any], at node: String) throws -> (node: [AnyEncodable], rules: AnyEncodable?) {
		var encodableArray = [AnyEncodable]()
		let matchingRules: AnyEncodable? = nil

		do {
			try array
				.enumerated()
				.forEach {
					let childElement = try process(element: $0.element, at: "\(node)[\($0.offset)]")
					if let value = childElement.node { encodableArray.append(value) }
					if let rules = childElement.rules {
						print("#### ARRAY RULES: ")
						print("\(rules)")
					}
				}
			return (node: encodableArray, rules: matchingRules)
		} catch {
			throw EncodingError.notEncodable(array)
		}
	}

	func process(_ dictionary: [String: Any], at node: String) throws -> (node: [String: AnyEncodable], rules: AnyEncodable?) {
		var encodableDictionary: [String: AnyEncodable] = [:]
		var matchingRules: [String: [String: [[String: AnyEncodable]]]] = [:]
		do {
			try dictionary
				.enumerated()
				.forEach { dict in
					let childElement = try process(element: dict.element.value, at: "\(node).\(dict.element.key)")
					encodableDictionary[dict.element.key] = childElement.node
					matchingRules = ["\(node).\(dict.element.key)": ["matchers": [["match": AnyEncodable("type")]]]]
				}
			return (node: encodableDictionary, rules: AnyEncodable(matchingRules))
		} catch {
			throw EncodingError.notEncodable(dictionary)
		}
	}

}
