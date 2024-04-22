//
//  HTTPMethod.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `GET` method.
    public static let get: HTTPMethod = HTTPMethod(rawValue: "GET")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
