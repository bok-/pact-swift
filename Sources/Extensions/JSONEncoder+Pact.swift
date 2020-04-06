//
//  JSONEncoder+Pact.swift
//  PactSwift
//
//  Created by Marko Justinek on 6/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

extension JSONEncoder {

	static var pactEncoding: JSONEncoder {
		let jsonEncoder = JSONEncoder()
		jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]

		return jsonEncoder
	}

}
