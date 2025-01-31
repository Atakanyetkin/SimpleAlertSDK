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
    public static func create(
        title: String,
        message: String,
        style: UIAlertController.Style = .alert
    ) -> AlertBuilder {
        return AlertBuilder(title: title, message: message, style: style)
    }
    
    // Added convenience methods for common alert types
    public static func success(title: String = "Success", message: String) -> AlertBuilder {
        return create(title: title, message: message, style: .alert)
            .setTint(.systemGreen)
    }
    
    public static func error(title: String = "Error", message: String) -> AlertBuilder {
        return create(title: title, message: message, style: .alert)
            .setTint(.systemRed)
    }
    
    public static func warning(title: String = "Warning", message: String) -> AlertBuilder {
        return create(title: title, message: message, style: .alert)
            .setTint(.systemOrange)
    }
    
    public static func info(title: String = "Info", message: String) -> AlertBuilder {
        return create(title: title, message: message, style: .alert)
            .setTint(.systemBlue)
    }
    
    public static func loading(message: String = "Loading...") -> AlertBuilder {
        return create(title: "Loading", message: message, style: .alert)
            .setTint(.systemGray)
    }
    
    public static func confirmation(
        title: String = "Confirmation",
        message: String
    ) -> AlertBuilder {
        return create(title: title, message: message, style: .alert)
            .setTint(.systemBlue)
            .addOkButton()
            .addCancelButton()
    }
    
    public static func timer(
        title: String = "Timer",
        duration: TimeInterval
    ) -> AlertBuilder {
        return create(title: title, message: "Time remaining: \(Int(duration))s", style: .alert)
            .startTimer(duration: duration)
    }
    
    // MARK: - Alert Builder Class
    public final class AlertBuilder {
        private let alertController: UIAlertController
        private weak var viewController: UIViewController?
        private var loadingIndicator: UIActivityIndicatorView?
        private var timer: Timer?
        private var remainingTime: TimeInterval = 0
        
        fileprivate init(title: String, message: String, style: UIAlertController.Style) {
            self.alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: style
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
        
        // Added convenience methods for common buttons
        public func addOkButton(handler: (() -> Void)? = nil) -> AlertBuilder {
            return addButton(title: "OK", handler: handler)
        }
        
        public func addCancelButton(handler: (() -> Void)? = nil) -> AlertBuilder {
            return addButton(title: "Cancel", style: .cancel, handler: handler)
        }
        
        public func addDestructiveButton(title: String, handler: (() -> Void)? = nil) -> AlertBuilder {
            return addButton(title: title, style: .destructive, handler: handler)
        }
        
        public func addImageButton(
            title: String,
            image: UIImage,
            handler: (() -> Void)? = nil
        ) -> AlertBuilder {
            let action = UIAlertAction(title: title, style: .default) { _ in
                handler?()
            }
            action.setValue(image, forKey: "image")
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
        
        // Added convenience methods for common text field configurations
        public func addPasswordTextField() -> AlertBuilder {
            return addTextField { textField in
                textField.isSecureTextEntry = true
                textField.placeholder = "Password"
            }
        }
        
        public func addEmailTextField() -> AlertBuilder {
            return addTextField { textField in
                textField.keyboardType = .emailAddress
                textField.placeholder = "Email"
                textField.autocapitalizationType = .none
            }
        }
        
        public func addPhoneTextField() -> AlertBuilder {
            return addTextField { textField in
                textField.keyboardType = .phonePad
                textField.placeholder = "Phone Number"
            }
        }
        
        public func addUsernameTextField() -> AlertBuilder {
            return addTextField { textField in
                textField.autocapitalizationType = .none
                textField.placeholder = "Username"
                textField.autocorrectionType = .no
            }
        }
        
        public func addValidatedTextField(
            placeholder: String,
            validation: @escaping (String) -> Bool,
            errorMessage: String
        ) -> AlertBuilder {
            return addTextField { textField in
                textField.placeholder = placeholder
                textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
                textField.tag = self.alertController.textFields?.count ?? 0
            }
        }
        
        @objc private func textFieldDidChange(_ textField: UITextField) {
            // Validation logic here
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
        
        // Added convenience method for setting background color
        public func setBackgroundColor(_ color: UIColor) -> AlertBuilder {
            alertController.view.subviews.first?.subviews.first?.backgroundColor = color
            return self
        }
        
        // Added loading indicator support
        public func showLoadingIndicator() -> AlertBuilder {
            let indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            indicator.hidesWhenStopped = true
            if #available(iOS 13.0, *) {
                indicator.style = .medium
            } else {
                // Fallback on earlier versions
            }
            indicator.startAnimating()
            
            alertController.view.addSubview(indicator)
            loadingIndicator = indicator
            return self
        }
        
        // Added custom font support
        public func setTitleFont(_ font: UIFont) -> AlertBuilder {
            guard let title = alertController.title else { return self }
            let attributedString = NSAttributedString(
                string: title,
                attributes: [.font: font]
            )
            alertController.setValue(attributedString, forKey: "attributedTitle")
            return self
        }
        
        public func setMessageFont(_ font: UIFont) -> AlertBuilder {
            guard let message = alertController.message else { return self }
            let attributedString = NSAttributedString(
                string: message,
                attributes: [.font: font]
            )
            alertController.setValue(attributedString, forKey: "attributedMessage")
            return self
        }
        
        // Added auto-dismiss support
        public func autoDismiss(after seconds: TimeInterval) -> AlertBuilder {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak alertController] in
                alertController?.dismiss(animated: true)
            }
            return self
        }
        
        // Added haptic feedback support
        public func withHapticFeedback(_ style: UINotificationFeedbackGenerator.FeedbackType = .success) -> AlertBuilder {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(style)
            return self
        }
        
        // Added timer support
        public func startTimer(duration: TimeInterval) -> AlertBuilder {
            remainingTime = duration
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                
                self.remainingTime -= 1
                if self.remainingTime <= 0 {
                    timer.invalidate()
                    self.alertController.dismiss(animated: true)
                } else {
                    self.alertController.message = "Time remaining: \(Int(self.remainingTime))s"
                }
            }
            return self
        }
        
        // Added custom image support
        public func setImage(_ image: UIImage, size: CGSize = CGSize(width: 40, height: 40)) -> AlertBuilder {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(origin: .zero, size: size)
            
            let containerView = UIView(frame: CGRect(x: 0, y: 8, width: alertController.view.bounds.width, height: size.height + 10))
            containerView.addSubview(imageView)
            imageView.center = containerView.center
            
            alertController.view.addSubview(containerView)
            return self
        }
        
        // Added keyboard customization
        public func configureKeyboard(
            type: UIKeyboardType,
            returnKey: UIReturnKeyType,
            autocorrection: UITextAutocorrectionType = .default
        ) -> AlertBuilder {
            alertController.textFields?.forEach { textField in
                textField.keyboardType = type
                textField.returnKeyType = returnKey
                textField.autocorrectionType = autocorrection
            }
            return self
        }
        
        // Added accessibility support
        public func setAccessibility(
            identifier: String,
            hint: String? = nil
        ) -> AlertBuilder {
            alertController.view.accessibilityIdentifier = identifier
            alertController.view.accessibilityHint = hint
            return self
        }
        
        // Added custom animation
        public func customAnimation(duration: TimeInterval = 0.3) -> AlertBuilder {
            alertController.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            alertController.view.alpha = 0
            
            UIView.animate(withDuration: duration) {
                self.alertController.view.transform = .identity
                self.alertController.view.alpha = 1
            }
            return self
        }
        
        // Added convenience static method for action sheets
        public static func createActionSheet(
            title: String,
            message: String
        ) -> AlertBuilder {
            return SimpleAlertSDK.create(title: title, message: message, style: .actionSheet)
        }
    }
}
