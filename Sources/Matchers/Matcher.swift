//
//  Matcher.swift
//  PactSwift
//
//  Created by Marko Justinek on 9/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

public enum Matcher {

	case type(SomethingLike)

	init?(_ matcher: MatchingRuleExpressible) {
		switch matcher {
		case let this as SomethingLike: self = .type(this)
		default: return nil
		}
	}

}

public extension Matcher {

	var value: String {
		switch self {
		case .type(let matcher): return "\(matcher.value)"
		}
	}

}
