//
//  TypeMatcher.swift
//  PactSwift
//
//  Created by Marko Justinek on 9/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

public struct SomethingLike<T: Encodable>: MatchingRuleExpressible {

	let value: AnyEncodable
	let rule: [String: String] = ["match": "type"]

	init(_ value: T) {
		self.value = AnyEncodable(value)
	}

}
