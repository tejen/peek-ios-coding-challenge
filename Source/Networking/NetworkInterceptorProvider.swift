//
//  NetworkInterceptorProvider.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import Apollo

struct NetworkInterceptorProvider: InterceptorProvider {
    
    /// Boilerplate Apollo code for Authentication Handling from https://www.apollographql.com/docs/ios/tutorial/tutorial-mutations/#add-authentication-handling
    
    private let store: ApolloStore
    private let client: URLSessionClient
    
    init(store: ApolloStore,
         client: URLSessionClient) {
        self.store = store
        self.client = client
    }
    
    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: self.store),
            UserManagementInterceptor(),
            NetworkFetchInterceptor(client: self.client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(cacheKeyForObject: self.store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: self.store)
        ]
    }
}
