//
//  MainVM.swift
//  ExpandableTableView
//
//  Created by Rumah Ulya on 07/11/18.
//  Copyright © 2018 Rumah Ulya. All rights reserved.
//

import Foundation

enum ItemType {
    case nameAndPicture
    case about
    case email
    case attribute
    case friend
}

protocol ItemBaseModel {
    var type: ItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
    var isCollapsible: Bool { get }
    var isCollapsed: Bool { get set }
}


class MainVM: NSObject {
    
    func getDataItems(result: @escaping(_ data: [ItemBaseModel]) -> ()) {
        var items = [ItemBaseModel]()
        
        let jsonData = dataFromFile("data")
        let response = try? JSONDecoder().decode(DataResponse.self, from: jsonData!)
        if let content = response?.data {
            if let name = content.fullName, let pictureUrl = content.pictureURL {
                let nameAndPicture = ItemNameAndPicture(name: name, pictureUrl: pictureUrl)
                items.append(nameAndPicture)
            }
            
            if let about = content.about {
                let aboutItem = ItemAbout(about: about)
                items.append(aboutItem)
            }
            
            if let email = content.email {
                let emailItem = ItemEmail(email: email)
                items.append(emailItem)
            }
            
            let attributes = content.profileAttributes
            if !attributes.isEmpty {
                let attributesItem = ItemAttribute(attributes: attributes)
                items.append(attributesItem)
            }
            
            let friends = content.friends
            if !friends.isEmpty {
                let friendsItems = ItemFriends(friends: friends)
                items.append(friendsItems)
            }
        }
            
        result(items)
        
    }
    
}

class ItemNameAndPicture: ItemBaseModel {
    var type: ItemType = .nameAndPicture
    var sectionTitle: String = "User Info"
    var rowCount: Int = 1
    var isCollapsible: Bool = true
    var isCollapsed = true
    
    var name: String
    var pictureUrl: String
    init(name: String, pictureUrl: String) {
        self.name = name
        self.pictureUrl = pictureUrl
    }
}

class ItemAbout: ItemBaseModel {
    var type: ItemType = .about
    var sectionTitle: String = "About"
    var rowCount: Int = 1
    var isCollapsible: Bool = true
    var isCollapsed: Bool = true
    var about: String
    
    init(about: String) {
        self.about = about
    }
}

class ItemEmail: ItemBaseModel {
    var type: ItemType  = .email
    var sectionTitle: String = "Email"
    var rowCount: Int = 1
    var isCollapsible: Bool = true
    var isCollapsed: Bool = true
    var email: String
    
    init(email: String) {
        self.email = email
    }
}

class ItemAttribute: ItemBaseModel {
    var type: ItemType = .attribute
    var sectionTitle: String = "Attribute"
    var isCollapsible: Bool = true
    var isCollapsed: Bool = true
    
    var attributes: [ProfileAttribute]
    var rowCount: Int
    
    init(attributes: [ProfileAttribute]) {
        self.attributes = attributes
        self.rowCount = attributes.count
    }
}

class ItemFriends: ItemBaseModel {
    var type: ItemType = .friend
    var sectionTitle: String = "Friends"
    var rowCount: Int
    var isCollapsible: Bool = true
    var isCollapsed: Bool = true
    
    var friends: [Friend]
    
    init(friends: [Friend]) {
        self.friends = friends
        self.rowCount = friends.count
    }
    
}


