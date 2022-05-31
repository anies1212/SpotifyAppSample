//
//  AuthManager.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/02.
//

import Foundation
import UIKit


final class AuthManagaer{
    static let shared = AuthManagaer()
    private var refreshingToken = false
    struct Constants{
        static let clientID = "7461ea161ae248188c154523c6f607cc"
        static let clientSecret = "5ba6a26c4a4f44d2a926db9fba9489bb"
        static let tokenApiUrl = "https://accounts.spotify.com/api/token"
        static let redirectUri = "https://aniesataawuk.wixsite.com/website/contact"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    private init() {}
    
    public var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize?"
        let string = "\(baseURL)response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectUri)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    ///Get Token
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool)->Void)){
        guard let url = URL(string: Constants.tokenApiUrl) else {return}
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri)
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to Get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let strongSelf = self else {return}
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                strongSelf.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    private var onRefreshBlocks = [(String)-> Void]()
    ///Supplies valid token to be used with api calls
    public func withValidToken(completion: @escaping (String)-> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            refreshIfNeeded {[weak self] success in
                if success {
                    if let token = self?.accessToken, success {
                        completion(token)
                    }
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshIfNeeded(completion: ((Bool)-> Void)?){
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        guard let refreshToken = refreshToken else {
            return
        }
        ///Refresh the token
        guard let url = URL(string: Constants.tokenApiUrl) else {return}
        refreshingToken = true
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to Get base64")
            completion?(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            self?.refreshingToken = false
            guard let strongSelf = self else {return}
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach{$0(result.access_token)}
                self?.onRefreshBlocks.removeAll()
                strongSelf.cacheToken(result: result)
                completion?(true)
            } catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
        
        
    }
    
    private func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token,
                                       forKey:"access_token")
        if let _ = result.refresh_token{
            UserDefaults.standard.setValue(result.refresh_token,
                                           forKey:"refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)),
                                       forKey:"expirationDate")
    }
    
}
