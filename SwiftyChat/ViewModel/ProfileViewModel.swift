//
//  ProfileViewModel.swift
//  SwiftyChat
//
//  Created by John McCants on 12/31/21.
//

import Foundation
import UIKit
import FirebaseAuth

enum ProfileViewModel: Int, CaseIterable {
    case accountInfo = 0
    case settings = 1
    
    var description: String {
        switch self {
        case .accountInfo: return "Account Info"
        case.settings: return "Settings"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        case .settings: return "gear"
        }
    }
}

