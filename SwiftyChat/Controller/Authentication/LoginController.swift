//
//  LoginController.swift
//  SwiftyChat
//
//  Created by John McCants on 12/20/21.
//

import Foundation
import UIKit
import Firebase

protocol AuthenticationControllerProtocol {
    func checkFormStatus()
}

class LoginController: UIViewController {
    
    private var viewModel = LoginViewModel()
    
    private let iconImage : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        let containerView = InputContainerView(image: UIImage(systemName: "envelope"), textField: emailTextField)
        return containerView
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        let containerView = InputContainerView(image: UIImage(systemName: "lock"), textField: passwordTextField)
        return containerView

    }()
    
    private let emailTextField: CustomTextField = {
        return CustomTextField(placeholder: "Email")
    }()
    
    private let passwordTextField: UITextField = {
       return CustomTextField(placeholder: "Password")
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: " Sign Up", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(showHandleSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(width: 120, height: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingBottom: 20, paddingRight: 32)
        
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
    }
    
    
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    
    // MARK: - Selectors
    
    @objc func showHandleSignUp() {
        print("Show sign up page")
        let controller = RegistrationController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        print("Debug: Sender text is \(sender.text)")
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    @objc func handleLogin() {
        print("Handle Login")
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        AuthService.shared.logUserIn(email: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Error logging in user: \(error.localizedDescription)")
                return 
            }
            self.dismiss(animated: true, completion: nil)
        }
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                print("DEBUG Error Signing In: \(error.localizedDescription)")
//                return
//            }
//            self.dismiss(animated: true, completion: nil)
//        }
        print("DEBUG: User login successful")
    }
}

extension LoginController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .systemPink
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .lightGray
        }
    }
}
