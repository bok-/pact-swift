//
//  Request.swift
//  PactSwift
//
//  Created by Marko Justinek on 31/3/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

public struct Request: Encodable {

	let method: PactHTTPMethod
	let path: String
	let query: [String: [String]]?
	let headers: [String: String]?
	let body: Any?
	let matchingRules: String?

	private let bodyEncoder: (Encoder) throws -> Void

	init<T: Encodable>(method: PactHTTPMethod, path: String, query: [String: [String]]? = nil, headers: [String: String]? = nil, body: T? = nil, matchingRules: String? = nil) {
		self.method = method
		self.path = path
		self.query = query
		self.headers = headers
		self.body = body
		self.matchingRules = matchingRules

		self.bodyEncoder = {
			var container = $0.container(keyedBy: CodingKeys.self)
			try container.encode(method, forKey: .method)
			try container.encode(path, forKey: .path)
			if let query = query { try container.encode(query, forKey: .query) }
			if let headers = headers { try container.encode(headers, forKey: .headers) }
			if let body = body { try container.encode(body, forKey: .body) }
			if let matchingRules = matchingRules { try container.encode(matchingRules, forKey: .matchingRules) }
		}
	}

	enum CodingKeys: String, CodingKey {
		case method
		case path
		case query
		case headers
		case body
		case matchingRules
	}

	public func encode(to encoder: Encoder) throws {
		try bodyEncoder(encoder)
	}

}
