//
//  Post.swift
//  DearDiary
//
//  Created by  Ronit D. on 7/20/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _username: String!
    private var _userImage: String!
    private var _postedText: String!
    private var _postKey:  String!
    private var _postRef: DatabaseReference!
    
    var username: String {
        return _username
    }
    
    var userImage: String {
        return _userImage
    }
    
    var postedText: String {
        return _postedText
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(postText: String, username: String, userImg: String) {
        _postedText = postedText
        _username = username
        _userImage = userImage
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        _postKey = postKey
        
        if let username = postData["username"] as? String {
            _username = username
        }
        
        if let userImage = postData["userImage"] as? String {
            _userImage = userImage
        }
        
        if let postedText = postData["postedText"] as? String {
            _postedText = postedText
        }
        
        _postRef = Database.database().reference().child("posts").child(_postKey)
    }
}
