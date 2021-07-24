//
//  Network.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import Apollo

class Network {
    static let shared = Network()
    
    private(set) lazy var apollo: ApolloClient = {
        /// Boilerplate Apollo code for Authentication Handling from https://www.apollographql.com/docs/ios/tutorial/tutorial-mutations/#add-authentication-handling
        
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        
        let client = URLSessionClient()
        let provider = NetworkInterceptorProvider(store: store, client: client)
        let url = URL(string: "https://api.github.com/graphql")!
        
        let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                                 endpointURL: url)
        
        return ApolloClient(networkTransport: requestChainTransport,
                            store: store)
    }()
}
