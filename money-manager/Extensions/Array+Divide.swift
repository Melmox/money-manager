//
//  Array+Divide.swift
//  money-manager
//
//  Created by developer on 17.04.2024.
//

import Foundation

extension Array {
    func divide(comparator: (Element, Element) -> Bool) -> [[Element]] {
        var result: [[Element]] = []
        
        var section: [Element] = []
        
        forEach {
            if let obj1: Element = section.last {
                if comparator(obj1, $0) {
                    section.append($0)
                } else {
                    result.append(section)
                    section = [$0]
                }
            } else {
                section.append($0)
            }
        }
        
        result.append(section)
        
        return result
    }
}
