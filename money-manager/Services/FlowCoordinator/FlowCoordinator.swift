//
//  FlowCoordinator.swift
//  money-manager
//
//  Created by developer on 13.04.2024.
//

import UIKit

protocol IFlowCoordinator {
    func start()
}

final class FlowCoordinator: IFlowCoordinator {
    
    // MARK: - Properties
    
    private weak var window: UIWindow?
    private let mainAssembly: IMainAssembly
    
    // MARK: - Initialization

    init(window: UIWindow, mainAssembly: IMainAssembly = MainAssembly()) {
        self.window = window
        self.mainAssembly = mainAssembly
    }
    
    // MARK: - Private functions
    
    private func switchTo(_ viewController: UIViewController) {
        let snapShot: UIView? = window?.snapshotView(afterScreenUpdates: true)
        if let snapShot: UIView = snapShot {
            window?.addSubview(snapShot)
        }
        dismiss(viewController) { [weak self] in
            self?.window?.rootViewController = viewController
            if let snapShot: UIView = snapShot {
                self?.window?.bringSubviewToFront(snapShot)
                UIView.animate(withDuration: 0.3, animations: {
                    snapShot.layer.opacity = 0
                }, completion: { _ in
                    DispatchQueue.main.async {
                        snapShot.removeFromSuperview()
                    }
                })
            }
        }
    }
    
    private func dismiss(_ viewController: UIViewController, completion: @escaping () -> Void) {
        if viewController.presentedViewController != nil {
            self.dismiss(viewController, completion: {
                viewController.dismiss(animated: false, completion: {
                    completion()
                })
            })
        } else {
            completion()
        }
    }

    
    private func switchToStart() {
        switchTo(mainAssembly.assemble())
    }

    // MARK: - IFlowCoordinator
    
    func start() {
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        
        switchToStart()
    }
    
    
}
