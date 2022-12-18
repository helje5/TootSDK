// Created by konstantin on 18/11/2022.
// Copyright (c) 2022. All rights reserved.

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension TootClient {
    
    internal func getURL(_ components: [String]) -> URL {
        var url = instanceURL
        for component in components {
            url.appendPathComponent(component)
        }
        return url
    }
    
    internal func getQueryParams(_ pageInfo: PagedInfo? = nil, limit: Int? = nil) -> [URLQueryItem] {
        var queryParameters = [URLQueryItem]()
        
        if let maxId = pageInfo?.maxId {
            queryParameters.append(.init(name: "max_id", value: maxId))
        }

        if let minId = pageInfo?.minId {
            queryParameters.append(.init(name: "min_id", value: minId))
        }

        if let sinceId = pageInfo?.sinceId {
            queryParameters.append(.init(name: "since_id", value: sinceId))
        }

        if let limit = limit {
            queryParameters.append(.init(name: "limit", value: String(limit)))
        }
        return queryParameters
    }

    internal func getAuthorizationInfo(callbackUrl: String,
                                       scopes: [String],
                                       website: String = "",
                                       responseType: String = "code",
                                       clientName: String = "TootSDK") async throws -> CallbackInfo? {
        
        let createAppData = CreateAppRequest(clientName: clientName,
                                             redirectUris: callbackUrl,
                                             scopes: scopes.joined(separator: " "), website: website)
        
        let registerAppReq = try HttpRequestBuilder {
            $0.url = getURL(["api", "v1", "apps"])
            $0.method = .post
            $0.body = try .json(createAppData, encoder: self.encoder)
        }
        
        let app = try await fetch(TootApplication.self, registerAppReq)
        
        guard let app, let clientId = app.clientId else {
            return nil
        }
                
        let signUrlReq = HttpRequestBuilder {
            $0.url = getURL(["oauth", "authorize"])
            $0.addQueryParameter(name: "client_id", value: clientId)
            $0.addQueryParameter(name: "redirect_uri", value: callbackUrl)
            $0.addQueryParameter(name: "scope", value: scopes.joined(separator: " "))
            $0.addQueryParameter(name: "response_type", value: responseType)
        }
        
        guard let url = signUrlReq.url else {
            return nil
        }
        
        return .init(url: url, application: app)
    }
    

    internal func getAccessToken(code: String, clientId: String, clientSecret: String, callbackUrl: String, grandType: String = "authorization_code", scopes: [String] = ["read", "write", "follow", "push"]) async throws -> AccessToken? {

        let queryItems: [URLQueryItem] = [
            .init(name: "client_id", value: clientId),
            .init(name: "client_secret", value: clientSecret),
            .init(name: "grant_type", value: grandType),
            .init(name: "scope", value: scopes.joined(separator: " ")),
            .init(name: "code", value: code),
            .init(name: "redirect_uri", value: callbackUrl)
        ]

        let req = try HttpRequestBuilder {
            $0.url = getURL(["oauth", "token"])
            $0.method = .post
            $0.body = try .form(queryItems: queryItems)
        }

        return try await fetch(AccessToken.self, req)
    }
}
