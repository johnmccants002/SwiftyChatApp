//
//  LoginViewModel.swift
//  SwiftyChat
//
//  Created by John McCants on 12/25/21.
//

import Foundation


struct LoginViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
