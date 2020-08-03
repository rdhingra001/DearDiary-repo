//
//  CurrentChatViewController.swift
//  DearDiary
//
//  Created by  Ronit D. on 7/26/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

class CurrentChatViewController: MessagesViewController {
    
    private var message = [Message]()
    
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Joe Smith")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        message.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello world message")))

        message.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello world message. Hello world message")))
        view.backgroundColor = .link

    }
    
}

extension CurrentChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return message[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return message.count
        
    }
    
    
}
