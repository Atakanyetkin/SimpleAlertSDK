//
//  ViewController.swift
//  denemesdk
//
//  Created by atakan yetkin on 31.01.2025.
//

import UIKit
import SimpleAlertSDK


class ViewController: UIViewController {
    
    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let basicAlertButton = UIButton(type: .system)
    private let successAlertButton = UIButton(type: .system)
    private let errorAlertButton = UIButton(type: .system)
    private let timerAlertButton = UIButton(type: .system)
    private let loginAlertButton = UIButton(type: .system)
    private let customAlertButton = UIButton(type: .system)
    private let actionSheetButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        
        // Arka plan rengini ayarla
        view.backgroundColor = .white
        
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Configure buttons
        [basicAlertButton, successAlertButton, errorAlertButton,
         timerAlertButton, loginAlertButton, customAlertButton,
         actionSheetButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(button)
        }
        
        basicAlertButton.setTitle("Basic Alert", for: .normal)
        successAlertButton.setTitle("Success Alert", for: .normal)
        errorAlertButton.setTitle("Error Alert", for: .normal)
        timerAlertButton.setTitle("Timer Alert", for: .normal)
        loginAlertButton.setTitle("Login Alert", for: .normal)
        customAlertButton.setTitle("Custom Alert", for: .normal)
        actionSheetButton.setTitle("Action Sheet", for: .normal)
        
        // Add stack view
        view.addSubview(stackView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - Actions Setup
    private func setupActions() {
        basicAlertButton.addTarget(self, action: #selector(showBasicAlert), for: .touchUpInside)
        successAlertButton.addTarget(self, action: #selector(showSuccessAlert), for: .touchUpInside)
        errorAlertButton.addTarget(self, action: #selector(showErrorAlert), for: .touchUpInside)
        timerAlertButton.addTarget(self, action: #selector(showTimerAlert), for: .touchUpInside)
        loginAlertButton.addTarget(self, action: #selector(showLoginAlert), for: .touchUpInside)
        customAlertButton.addTarget(self, action: #selector(showCustomAlert), for: .touchUpInside)
        actionSheetButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
    }
    
    // MARK: - Alert Actions
    @objc private func showBasicAlert() {
        SimpleAlertSDK.create(title: "Basic Alert", message: "This is a basic alert")
            .addOkButton()
            .addCancelButton()
            .show(on: self)
    }
    
    @objc private func showSuccessAlert() {
        SimpleAlertSDK.success(message: "Operation completed successfully!")
            .withHapticFeedback(.success)
            .autoDismiss(after: 2.0)
            .addOkButton()
            .show(on: self)
    }
    
    @objc private func showErrorAlert() {
        SimpleAlertSDK.error(message: "Something went wrong!")
            .withHapticFeedback(.error)
            .setTitleFont(.boldSystemFont(ofSize: 20))
            .addButton(title: "Retry") {
                print("Retrying...")
            }
            .addCancelButton()
            .show(on: self)
    }
    
    @objc private func showTimerAlert() {
        SimpleAlertSDK.timer(duration: 5)
            .addButton(title: "Stop Timer") {
                print("Timer stopped")
            }
            .show(on: self)
    }
    
    @objc private func showLoginAlert() {
        SimpleAlertSDK.create(title: "Login", message: "Enter your credentials")
            .addEmailTextField()
            .addPasswordTextField()
            .configureKeyboard(type: .emailAddress, returnKey: .next)
            .addButton(title: "Login") {
                print("Login tapped")
            }
            .addCancelButton()
            .show(on: self)
    }
    
    @objc private func showCustomAlert() {
        SimpleAlertSDK.create(title: "Custom Alert", message: "This is a custom styled alert")
            .setTint(.purple)
            .setBackgroundColor(.systemGray6)
            .setImage(UIImage(systemName: "star.fill")!)
            .customAnimation(duration: 0.5)
            .addImageButton(title: "Favorite", image: UIImage(systemName: "heart.fill")!) {
                print("Favorited!")
            }
            .addCancelButton()
            .show(on: self)
    }
    
    @objc private func showActionSheet() {
        SimpleAlertSDK.create(title: "Options", message: "Select an option", style: .actionSheet)
            .addButton(title: "Share") {
                print("Share tapped")
            }
            .addButton(title: "Edit") {
                print("Edit tapped")
            }
            .addDestructiveButton(title: "Delete") {
                print("Delete tapped")
            }
            .addCancelButton()
            .show(on: self)
    }
}

//// End of file. No additional code.
