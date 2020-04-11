//
//  TypeMatcher.swift
//  PactSwift
//
//  Created by Marko Justinek on 9/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

public struct SomethingLike: MatchingRuleExpressible {

	internal let value: Any
	internal let rule: [String: AnyEncodable] = ["match": AnyEncodable("type")]

	// MARK: - Initializers
	
	init(_ value: Any) {
		self.value = value
	}

}
