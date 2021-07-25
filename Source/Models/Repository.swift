//
//  Repository.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import Foundation

struct Repository {
    
    // - MARK: Properties
    
    let name: String
    let authorName: String
    let authorAvatarImageUrl: String
    let stargazerCount: Int
    
    // - MARK: Initializers
    
    init(from graphQLNode: SearchQuery.Data.Search.Edge.Node.AsRepository) {
        name = graphQLNode.name
        authorName = graphQLNode.owner.login
        authorAvatarImageUrl = graphQLNode.owner.avatarUrl
        stargazerCount = graphQLNode.stargazerCount
    }
}
