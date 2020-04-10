//
//  EachLike.swift
//  PactSwift
//
//  Created by Marko Justinek on 10/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

public struct EachLike: MatchingRuleExpressible {

	let value: Any
	let min: Int?
	let max: Int?

	var rule: [String: String] {
		var ruleValue = ["match": "type"]
		if let min = min { ruleValue["min"] = "\(min)" }
		if let max = max { ruleValue["max"] = "\(max)" }
		return ruleValue
	}

	// MARK: - Initializers

	init(_ value: Any) {
		self.value = [value]
		self.min = nil
		self.max = nil
	}

	init(_ value: Any, min: Int) {
		self.value = [value]
		self.min = min
		self.max = nil
	}

	init(_ value: Any, max: Int) {
		self.value = [value]
		self.min = nil
		self.max = max
	}

}
