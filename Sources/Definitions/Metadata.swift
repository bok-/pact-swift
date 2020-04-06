//
//  Metadata.swift
//  PactSwift
//
//  Created by Marko Justinek on 1/4/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

import Foundation

enum Metadata {

	typealias MetadataTypeValue = [String: [String: String]]

	static let values: MetadataTypeValue = [
			"pactSpecification": Metadata.pactSpecVersion,
			"pact-swift": Metadata.pactSwiftVersion
	]

	static private var pactSpecVersion: [String: String] {
		["version": "3.0.0"]
	}

	static private var pactSwiftVersion: [String: String] {
		["version": Bundle.pact.shortVersion!]
	}

}

extension Metadata: Encodable {

	enum CodingKeys: CodingKey {
		case values
		case pactSpecVersion
		case pactSwiftVersion
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(Self.values, forKey: .values)
		try container.encode(Self.pactSpecVersion, forKey: .pactSpecVersion)
		try container.encode(Self.pactSwiftVersion, forKey: .pactSwiftVersion)
	}

}
