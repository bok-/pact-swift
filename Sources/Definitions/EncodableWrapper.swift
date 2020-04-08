//
//  EncodableWrapper.swift
//  PactSwift
//
//  Created by Marko Justinek on 7/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

struct EncodableWrapper {

	let typeDefinition: Any

	init(for value: Any) {
		self.typeDefinition = value
	}

	/// Returns an object whose nodes and leaves conform to any `Encodable` value.
	///
	/// Transforms the following suppoerted types into `AnyEncodable`:
	///
	/// - `String`
	/// - `Int`
	/// - `Double`
	/// - `Array<Encodable>`
	/// - `Dictionary<String, Encodable>`
	///
	func asEncodable() throws -> AnyEncodable? {
		do {
			return try process(element: typeDefinition)
		} catch {
			throw EncodableWrapperError.notEncodable(typeDefinition)
		}
	}

}

extension EncodableWrapper {

	enum EncodableWrapperError: Error {
		case notEncodable(Any?)
		case unknown

		var localizedDescription: String {
			switch self {
			case .notEncodable(let element):
				return "Error casting '\(String(describing: element))' to a JSON safe Type (eg: String, Int, Double, Decimal, Bool, Dictionary<String, Encodable>, Array<Encodable>)" //swiftlint:disable:this line_length
			default: return "Error casting into an Encodable type"
			}
		}
	}

}

private extension EncodableWrapper {

	func process(element: Any) throws -> AnyEncodable? {
		let encodedElement: AnyEncodable?

		switch element {
		case let array as [Any]: encodedElement = AnyEncodable(try processArray(array))
		case let dict as [String: Any]: encodedElement = AnyEncodable(try processDictionary(dict))
		case let string as String: encodedElement = AnyEncodable(string)
		case let integer as Int: encodedElement = AnyEncodable(integer)
		case let double as Double: encodedElement = AnyEncodable(double)
		case let decimal as Decimal: encodedElement = AnyEncodable(decimal)
		case let bool as Bool: encodedElement = AnyEncodable(bool)
		default: throw EncodableWrapperError.notEncodable(element)
		}

		return encodedElement
	}

	func processArray(_ array: [Any]) throws -> [AnyEncodable] {
		var encodableArray = [AnyEncodable]()
		do {
			_ = try array.map {
				encodableArray.append(try process(element: $0)!)
			}
			return encodableArray
		} catch {
			throw EncodableWrapperError.notEncodable(array)
		}
	}

	func processDictionary(_ dictionary: [String: Any]) throws -> [String: AnyEncodable] {
		var encodableDictionary = [String: AnyEncodable]()
		do {
			_ = try dictionary.map {
				let childElement = try process(element: $1)!
				encodableDictionary = merge(encodableDictionary, with: [$0: childElement])
			}
			return encodableDictionary
		} catch {
			throw EncodableWrapperError.notEncodable(dictionary)
		}
	}

}
