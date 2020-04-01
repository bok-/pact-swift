//
//  Pact.swift
//  PactSwift
//
//  Created by Marko Justinek on 1/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

struct Pact {

	let consumer: Pacticipant
	let provider: Pacticipant

	var payload: [String: Any] {
		[
			"consumer": consumer.name,
			"provider": provider.name
		]
	}

}
