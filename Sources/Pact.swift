//
//  Pact.swift
//  PactSwift
//
//  Created by Marko Justinek on 1/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

struct Pact: Encodable {

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

	var data: Data? {
		do {
			return try JSONEncoder.pactEncoding.encode(self)
		} catch {
			debugPrint("\(error)")
		}
		return nil
	}

	// MARK - Private properties

	private let metadata = Metadata()

}
