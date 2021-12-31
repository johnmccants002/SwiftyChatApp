//
//  RegistrationViewModel.swift
//  SwiftyChat
//
//  Created by John McCants on 12/25/21.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct RegistrationViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
}
