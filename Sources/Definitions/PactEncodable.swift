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

	/// Returns a tuple of a Pact Contract interaction's node object (eg, request `body`) and its corresponding matching rules.
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
	func encoded() throws -> (node: AnyEncodable?, rules: Any?) {
		do {
			let value = try process(element: typeDefinition, at: "")
			return (node: value, rules: nil)
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
			default: return "Error casting into an Encodable type"
			}
		}
	}

}

private extension PactEncodable {

	func process(element: Any, at node: String) throws -> AnyEncodable? {
		let encodedElement: AnyEncodable?

		switch element {
		case let array as [Any]: encodedElement = AnyEncodable(try process(array, at: node))
		case let dict as [String: Any]: encodedElement = AnyEncodable(try process(dict, at: node))
		case let string as String: encodedElement = AnyEncodable(string)
		case let integer as Int: encodedElement = AnyEncodable(integer)
		case let double as Double: encodedElement = AnyEncodable(double)
		case let decimal as Decimal: encodedElement = AnyEncodable(decimal)
		case let bool as Bool: encodedElement = AnyEncodable(bool)
		default: throw EncodingError.notEncodable(element)
		}

		return encodedElement
	}

	func process(_ array: [Any], at node: String) throws -> [AnyEncodable] {
		var encodableArray = [AnyEncodable]()
		do {
			try array.enumerated().forEach { encodableArray.append(try process(element: $0.element, at: node)!) }
			return encodableArray
		} catch {
			throw EncodingError.notEncodable(array)
		}
	}

	func process(_ dictionary: [String: Any], at node: String) throws -> [String: AnyEncodable] {
		var encodableDictionary = [String: AnyEncodable]()
		do {
			try dictionary.enumerated().forEach { dict in
				let childElement = try process(element: dict.element.value, at: dict.element.key)!
				encodableDictionary = merge(encodableDictionary, with: [dict.element.key: childElement])
			}

			_ = try dictionary.map {
				let childElement = try process(element: $1, at: $0)!
				encodableDictionary = merge(encodableDictionary, with: [$0: childElement])
			}
			return encodableDictionary
		} catch {
			throw EncodingError.notEncodable(dictionary)
		}
	}

}
