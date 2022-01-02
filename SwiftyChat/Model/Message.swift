//
//  Message.swift
//  SwiftyChat
//
//  Created by John McCants on 12/31/21.
//

import Foundation
import Firebase


struct Message {
    let text: String
    let isFromCurrentUser: Bool
    let toId: String
    let fromId: String
    var timestamp: Timestamp!
    var user: User?
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}

struct Conversation {
    let user: User
    let message: Message
}
