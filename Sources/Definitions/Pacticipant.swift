//
//  Pacticipant.swift
//  PactSwift
//
//  Created by Marko Justinek on 1/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

public enum Pacticipant {

	case consumer(String)
	case provider(String)

	var name: [String: String] {
		switch self {
		case .consumer(let name),
				 .provider(let name):
			return ["name": name]
		}
	}

}

extension Pacticipant: Encodable {

	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(name)
	}

}
