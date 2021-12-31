//
//  RegistrationController.swift
//  SwiftyChat
//
//  Created by John McCants on 12/20/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import grpc

class RegistrationController: UIViewController {
    
    private var viewModel = RegistrationViewModel()
    private var profileImage : UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: " Log In", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleAlreadyAccount), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
       return InputContainerView(image: UIImage(systemName: "envelope"), textField: emailTextField)
    }()
    
    private lazy var fullnameContainerView: UIView = {
        return InputContainerView(image: UIImage(named: "ic_person_outline_white_2x"), textField: fullnameTextField)
    }()
    
    private lazy var usernameContainerView: UIView = {
        return InputContainerView(image: UIImage(named: "ic_person_outline_white_2x"), textField: usernameTextField)
    }()
    
    private lazy var passwordContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "lock"), textField: passwordTextField)
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        button.addTarget(self, action: #selector(handleSignUpTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullnameTextField = CustomTextField(placeholder: "Full Name")
    private let usernameTextField = CustomTextField(placeholder: "Username")
    
    private let passwordTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        configureUI()
        configureNotificationObservers()
        
        
    }
    
    func configureUI() {
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: self.view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        plusPhotoButton.setDimensions(width: 200, height: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullnameContainerView, usernameContainerView,  signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
    }
    
    @objc func textDidChange(sender: UITextField) {
        switch sender {
        case emailTextField:
            viewModel.email = sender.text
        case passwordTextField:
            viewModel.password = sender.text
        case fullnameTextField:
            viewModel.fullname = sender.text
        case usernameTextField:
            viewModel.username = sender.text
        default: break
        }
        checkFormStatus()
    }
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleSignUpTapped() {
        guard let email = emailTextField.text else { return }
        guard let fullName = fullnameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let profileImage = profileImage else {
            return
        }
        
        let credentials = RegistrationCredentials(email: email, password: password, fullname: fullName, username: username, profileImage: profileImage)
        AuthService.shared.createUser(credentials: credentials) { error in
            if let error = error {
                print("DEBUG: Error creating user \(error.localizedDescription)")
                return 
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleAlreadyAccount() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 200 / 2
    
        dismiss(animated: true, completion: nil)
    }
}

extension RegistrationController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        if viewModel.formIsValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .systemPink
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .lightGray
        }
    }
}
