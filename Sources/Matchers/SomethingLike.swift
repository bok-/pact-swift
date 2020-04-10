//
//  TypeMatcher.swift
//  PactSwift
//
//  Created by Marko Justinek on 9/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

public struct SomethingLike: MatchingRuleExpressible {

	let value: Any
	let rule: [String: String] = ["match": "type"]

	init(_ value: Any) {
		self.value = value
	}

}
