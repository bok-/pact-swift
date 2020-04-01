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
	
}

extension Pacticipant {

	var name: [String: String] {
		switch self {
		case .consumer(let name),
				 .provider(let name):
			return ["name": name]
		}
	}

}
