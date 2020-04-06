//
//  Response.swift
//  PactSwift
//
//  Created by Marko Justinek on 31/3/20.
//  Copyright © 2020 PACT Foundation. All rights reserved.
//

struct Response: Encodable {

	var statusCode: Int
	var headers: [String: String]?
	var body: String? // TODO: - Any<T: Encodable>?
	var matchingRules: String? // TODO: - Any<T: Encodable>?

}
