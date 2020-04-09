//
//  Pact.swift
//  PactSwift
//
//  Created by Marko Justinek on 1/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

struct Pact: Encodable {

	private let metadata = Metadata()

	// MARK: - Properties

	let consumer: Pacticipant
	let provider: Pacticipant

	var interactions: [Interaction] = []

	var payload: [String: Any] {
		[
			"consumer": consumer.name,
			"provider": provider.name,
			"interactions": interactions,
			"metadata": metadata
		]
	}

	// TODO: - This should be a `func asData() throws -> Data`
	var data: Data? {
		do {
			return try JSONEncoder().encode(self)
		} catch {
			debugPrint("\(error)")
		}
		return nil
	}

}
