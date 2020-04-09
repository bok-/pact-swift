//
//  Response.swift
//  PactSwift
//
//  Created by Marko Justinek on 31/3/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

public struct Response {

	var statusCode: Int
	var headers: [String: String]?
	var body: Any?

	private let bodyEncoder: (Encoder) throws -> Void

}

extension Response: Encodable {

	enum CodingKeys: String, CodingKey {
		case statusCode = "status"
		case headers
		case body
	}

	///
	/// Creates an object representing a network `Response`.
	/// - Parameters:
	///		- statusCode: The status code of the API response
	///		- headers: Headers of the API response
	///		- body: Optional body in the API response
	///
	init(statusCode: Int, headers: [String: String]? = nil, body: Any? = nil) {
		self.statusCode = statusCode
		self.headers = headers

		var encodableBody: AnyEncodable?
		if let body = body {
			do {
				encodableBody = try PactEncodable(value: body).encoded(node: .body)
			} catch {
				fatalError("Can not instatiate a `Response` with non-encodable `body`.")
			}
		}

		self.bodyEncoder = {
			var container = $0.container(keyedBy: CodingKeys.self)
			try container.encode(statusCode, forKey: .statusCode)
			if let headers = headers { try container.encode(headers, forKey: .headers) }
			if let encodableBody = encodableBody { try container.encode(encodableBody, forKey: .body) }
		}

	}

	public func encode(to encoder: Encoder) throws {
		try bodyEncoder(encoder)
	}

}
