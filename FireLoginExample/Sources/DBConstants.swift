//
//  Constants.swift
//  FireLoginExample
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import Foundation

enum Constants {
    
    enum Collections {
        static let users = "users"
        static let posts = "posts"
        static let likes = "likes"
        static let messages = "messages"
        static let recent_messages = "recent_messages"
        static let feedbacks = "feedbacks"
        static let report_user = "report_user"
        static let report_post = "report_post"
        static let settings = "settings"
        static let unread_recent_messages = "unread"
        static let orders = "orders"
        static let payments = "payments"
        static let transfers = "transfers"
    }
    
    enum Storage {
        static let profilePicturesFolder = "profile pictures"
        static let postsFolder = "posts"
    }
    
    enum QueryConstants {
        static let createdBy = "createdBy.id"
        static let createdAt = "createdAt"
        static let timestamp = "timestamp"
        static let domain = "domain"
        static let owner = "owner.id"
        static let renter = "renter.id"
    }
    
    static let userDocumentID = "userId"
    static let userEmailID = "emailID"
    static let userFullName = "userFullName"
    static let userLikeDocumentId = "userLikeDocumentId"
    
}

enum ModelConstants {
    static let text = "text"
    static let timestamp = "timestamp"
    static let fromId = "fromId"
    static let toId = "toId"
    static let profileImageUrl = "profileImageUrl"
    static let email = "email"
}

enum AppConstants {
    
    enum CompressionQuality {
        static let profilePicture: Float = 0.2
    }
}
