//
//  AppDelegate.swift
//  money-manager
//
//  Created by developer on 13.04.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    var flowCoordinator: IFlowCoordinator?
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        flowCoordinator = FlowCoordinator(window: window)
        flowCoordinator?.start()

        return true
    }
}
