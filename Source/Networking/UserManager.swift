//
//  UserManager.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    private(set) lazy var token = Token()
    func renewToken(_ completion: (Token.RenewResult) -> ()) {
        // TODO: (wishlist) have this connect to GitHub OAuth and renew the token, if we ever implement GitHub Login/Logout for users.
        completion(.success(token: token))
    }
}

struct Token {
    // TODO: have this token persist on-device, if we ever implement GitHub Login/Logout for users.
    private(set) var value: String!
    let isExpired = true
    
    init() {
        do {
            // TODO: (wishlist) replace this hardcoded API key with a proper OAuth implementation, if we ever implement GitHub Login/Logout for users.
            value = try String(contentsOfFile: Bundle.main.path(forResource: "GitHubAPIKey", ofType: "txt") ?? "") // TODO: (wishlist) it would be better practice to use a Plist here instead of this txt file. Or even better, implement Sign In With GitHub functionality for the end-user, in order to entirely eliminate this usage of hard-coded API tokens.
            value = value.trimmingCharacters(in: .whitespacesAndNewlines)
            if value.isEmpty {
                fatalError("Please enter a GitHub Personal Access Token in Source/Networking/GitHubAPIKey.txt")
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    enum RenewResult {
        case failure(error: Error)
        case success(token: Token)
    }
}
