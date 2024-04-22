//
//  String+Double.swift
//  money-manager
//
//  Created by developer on 22.04.2024.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        Double(self.replacingOccurrences(of: ",", with: "."))
    }
}
