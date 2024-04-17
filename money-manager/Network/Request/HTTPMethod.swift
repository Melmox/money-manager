//
//  HTTPMethod.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect: HTTPMethod = HTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete: HTTPMethod = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get: HTTPMethod = HTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head: HTTPMethod = HTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options: HTTPMethod = HTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch: HTTPMethod = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post: HTTPMethod = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put: HTTPMethod = HTTPMethod(rawValue: "PUT")
    /// `QUERY` method.
    public static let query: HTTPMethod = HTTPMethod(rawValue: "QUERY")
    /// `TRACE` method.
    public static let trace: HTTPMethod = HTTPMethod(rawValue: "TRACE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
