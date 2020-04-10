//
//  EachLike.swift
//  PactSwift
//
//  Created by Marko Justinek on 10/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

public struct EachLike<T: Encodable>: MatchingRuleExpressible {

	let value: AnyEncodable // Value might need to be multiplied based on `min` and/or `max`
	let min: Int?
	let max: Int?

	var rule: [String : String] {
		var ruleValue = ["match": "type"]
		if let min = min { ruleValue["min"] = "\(min)" }
		if let max = max { ruleValue["max"] = "\(max)" }
		return ruleValue
	}

	// MARK: - Initializers

	init(_ value: T) {
		self.value = AnyEncodable([value])
		self.min = nil
		self.max = nil
	}

	init(_ value: T, min: Int) {
		self.value = AnyEncodable([value])
		self.min = min
		self.max = nil
	}

	init(_ value: T, max: Int) {
		self.value = AnyEncodable([value])
		self.min = nil
		self.max = max
	}

}
