//
//  MainViewModelFactory.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import Foundation

protocol IMainViewModelFactory {
    func makeViewModel() -> MainViewModel
}

final class MainViewModelFactory: IMainViewModelFactory {
    func makeViewModel() -> MainViewModel {
        MainViewModel()
    }
}
