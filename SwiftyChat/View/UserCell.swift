//
//  UserCell.swift
//  SwiftyChat
//
//  Created by John McCants on 12/31/21.
//

import Foundation
import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    
    var user : User? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
     let iv = UIImageView()
        iv.backgroundColor = .systemPurple
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "Charmander")
    return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Ash's Pokemon"
       return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(width: 56, height: 56)
        profileImageView.layer.cornerRadius = 56 / 2
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 2
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 15)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("initi(coder:) has not been implemented")
    }
    
    func configure() {
        guard let user = user else { return }
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullname
        
        guard let profileImageUrl = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: profileImageUrl, completed: nil)
    }
}
