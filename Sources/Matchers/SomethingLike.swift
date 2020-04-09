//
//  TypeMatcher.swift
//  PactSwift
//
//  Created by Marko Justinek on 9/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

/// A Type matcher
public struct SomethingLike: MatchingRuleExpressible {

	var value: Any
	var rule: [String: String] = ["match": "type"]

	init(_ value: Any) {
		self.value = value
	}

}
