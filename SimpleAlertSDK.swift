//
//  SimpleAlertSDK.swift
//  SimpleAlertSDK
//
//  Created by atakan yetkin on 31.01.2025.
//

import Foundation
import UIKit

public final class SimpleAlertSDK {
    
    // MARK: - Basic Alert (Legacy)
    @available(*, deprecated, message: "Use SimpleAlertSDK.create() builder instead")
    public static func show(
        title: String,
        message: String,
        buttonTitle: String,
        on viewController: UIViewController
    ) {
        create(title: title, message: message)
            .addButton(title: buttonTitle)
            .show(on: viewController)
    }
    
    // MARK: - Custom Color Alert (Legacy)
    @available(*, deprecated, message: "Use SimpleAlertSDK.create() builder instead")
    public static func showCustom(
        title: String,
        message: String,
        buttonTitle: String,
        buttonColor: UIColor,
        on viewController: UIViewController
    ) {
        create(title: title, message: message)
            .addButton(title: buttonTitle, color: buttonColor)
            .show(on: viewController)
    }
    
    // MARK: - New Builder Pattern
    public static func create(title: String, message: String) -> AlertBuilder {
        return AlertBuilder(title: title, message: message)
    }
    
    // MARK: - Alert Builder Class
    public final class AlertBuilder {
        private let alertController: UIAlertController
        private weak var viewController: UIViewController?
        
        fileprivate init(title: String, message: String) {
            self.alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
        }
        
        // MARK: - Button Configuration
        public func addButton(
            title: String,
            style: UIAlertAction.Style = .default,
            color: UIColor? = nil,
            handler: (() -> Void)? = nil
        ) -> AlertBuilder {
            let action = UIAlertAction(title: title, style: style) { _ in
                handler?()
            }
            
            if let color = color {
                action.setValue(color, forKey: "titleTextColor")
            }
            
            alertController.addAction(action)
            return self
        }
        
        // MARK: - Text Field Support
        public func addTextField(
            configuration: ((UITextField) -> Void)? = nil
        ) -> AlertBuilder {
            alertController.addTextField { textField in
                configuration?(textField)
            }
            return self
        }
        
        // MARK: - Presentation
        public func show(on viewController: UIViewController) {
            guard !alertController.actions.isEmpty else {
                fatalError("At least one button must be added before showing the alert")
            }
            
            viewController.present(alertController, animated: true)
        }
        
        // MARK: - Theming
        public func setTint(_ color: UIColor) -> AlertBuilder {
            alertController.view.tintColor = color
            return self
        }
    }
}
