//
//  StorageManager.swift
//  DearDiary
//
//  Created by  Ronit D. on 7/27/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import Foundation
import Firebase

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    public func uploadProfilePicture(withData: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("users").child("profile-pic").putData(withData, metadata: nil) { (metadata, err) in
            guard err == nil else {
                print("Error: \(err!)")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("users").downloadURL { (url, err) in
                guard url != nil else {
                    print("")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                
                let urlString = url!.absoluteString
                print("Download url returned: \(urlString)")
            }
        }
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
}
