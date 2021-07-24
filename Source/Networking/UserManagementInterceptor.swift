//
//  UserManagementInterceptor.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import Apollo

class UserManagementInterceptor: ApolloInterceptor {
    
    enum UserError: Error {
        case noUserLoggedIn
    }
    
    /// Helper function to add the token then move on to the next step of the network call
    /// For more details, see Apollo documentation for Adding Authentication Handling at https://www.apollographql.com/docs/ios/tutorial/tutorial-mutations/#add-authentication-handling
    private func addTokenAndProceed<Operation: GraphQLOperation>(
        _ token: Token,
        to request: HTTPRequest<Operation>,
        chain: RequestChain,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        
        request.addHeader(name: "Authorization", value: "Bearer \(token.value!)")
        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
    }
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        
        let token = UserManager.shared.token
        
        // If we've gotten here, there is a token!
        if token.isExpired {
            // Call an async method to renew the token
            UserManager.shared.renewToken { [weak self] tokenRenewResult in
                guard let self = self else {
                    return
                }
                
                /// **HEADS UP:** this code for renewing users' tokens is not particularly important at the moment, but it could become more relevant later down the line (i.e. if we ever implement GitHub Login/Logout for our users, this is ready to go.)
                
                switch tokenRenewResult {
                case .failure(let error):
                    // Pass the token renewal error up the chain, and do
                    // not proceed further. Note that you could also wrap this in a
                    // `UserError` if you want.
                    chain.handleErrorAsync(error,
                                           request: request,
                                           response: response,
                                           completion: completion)
                case .success(let token):
                    // Token renewal worked! Add the renewed token to the request and move on.
                    self.addTokenAndProceed(token,
                                            to: request,
                                            chain: chain,
                                            response: response,
                                            completion: completion)
                }
            }
        } else {
            // We don't need to wait for renewal, add token and move on
            self.addTokenAndProceed(token,
                                    to: request,
                                    chain: chain,
                                    response: response,
                                    completion: completion)
        }
    }
}
