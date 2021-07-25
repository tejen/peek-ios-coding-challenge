//
//  Repository.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import Foundation

struct Repository {
    let name: String
    let authorName: String
    let authorAvatarImageUrl: URL
    let stargazerCount: Int
    
    init(from graphQLNode: SearchQuery.Data.Search.Edge.Node.AsRepository) {
        name = graphQLNode.name
        authorName = graphQLNode.owner.login
        authorAvatarImageUrl = URL(string: graphQLNode.owner.avatarUrl)!
        stargazerCount = graphQLNode.stargazerCount
    }
}
