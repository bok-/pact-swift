//
//  Interaction.swift
//  PactSwift
//
//  Created by Marko Justinek on 1/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

struct Interaction {

	let description: String
	var providerState: String? = nil
	var providerStates: [ProviderState]? = nil
	let request: Request
	let response: Response

	init(description: String, providerState: String, request: Request, response: Response) {
		self.description = description
		self.providerState = providerState
		self.request = request
		self.response = response
	}

	init(description: String, providerStates: [ProviderState], request: Request, response: Response) {
		self.description = description
		self.providerStates = providerStates
		self.request = request
		self.response = response
	}

}
