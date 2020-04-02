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
	let providerState: String?
	let providerStates: ProviderState?
	let request: Request
	let response: Response

	init(description: String, providerState: String? = nil, providerStates: ProviderState? = nil, request: Request, response: Response) {
		self.description = description
		self.providerState = providerState
		self.providerStates = providerStates
		self.request = request
		self.response = response
	}

}
