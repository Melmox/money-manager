//
//  UIButton+Action.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

private final class ActionClosureWrapper: NSObject {
    let closure: (() -> Void)?
    init(closure: (() -> Void)?) {
        self.closure = closure
    }
}

extension UIButton {

    private struct AssociatedKeys {
        static var primaryActionClosure: Int = 0
    }

    var primaryActionClosure: (() -> Void)? {
        get {
            let wrapper: ActionClosureWrapper? = objc_getAssociatedObject(self, &AssociatedKeys.primaryActionClosure) as? ActionClosureWrapper
            return wrapper?.closure
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.primaryActionClosure, ActionClosureWrapper(closure: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.addTarget(self, action: #selector(onPrimaryAction(_:)), for: .primaryActionTriggered)
        }
    }

    @objc
    private func onPrimaryAction(_ sender: UIButton) {
        primaryActionClosure?()
    }
}
