//
//  MainAssembly.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

protocol IMainAssembly {
    func assemble() -> UIViewController
}

final class MainAssembly: IMainAssembly {

    func assemble() -> UIViewController {
        UIViewController()
    }
}
