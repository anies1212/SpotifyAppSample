//
//  APICaller.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/02.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    private init() {}
    struct Constants {
        static let baseApiUrl = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error{
        case failedToGetData
    }
    
    //MARK: -Albums
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>)-> Void ){
        createRequest(with: URL(string: Constants.baseApiUrl + "/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    //MARK: -Playlists
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>)-> Void ){
        createRequest(with: URL(string: Constants.baseApiUrl + "/playlists/" + playlist.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    //MARK: -Profile
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>)-> Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/me"), type: .GET) {baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: -Browse
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/browse/new-releases?limit=50"), type: .GET) {request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: -FeaturedPlaylist
    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistResponse, Error>)-> Void)){
        createRequest(with: URL(string: Constants.baseApiUrl + "/browse/featured-playlists?limit=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: -Recommendations
    public func getRecommendations(genres:Set<String>, completion: @escaping ((Result<RecommendationsResponse,Error>)->Void)){
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseApiUrl + "/recommendations?limit=40&seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let results = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse,Error>)->Void)){
        createRequest(with: URL(string: Constants.baseApiUrl + "/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: -Category
    
    public func getCategories(completion: @escaping (Result<[Category],Error>)->Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/browse/categories/?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let results = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completion(.success(results.categories.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoriesPlaylists(category: Category,completion: @escaping (Result<[Playlist],Error>)->Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/browse/categories/\(category.id)/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let results = try JSONDecoder().decode(CategoryPlaylistResponse.self, from: data)
                    let playlists = results.playlists.items
                    completion(.success(playlists))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: -Search
    public func search(with query: String, completion: @escaping (Result<[SearchResult],Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseApiUrl + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            print(request.url?.absoluteURL ?? "none")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    var searchResult:[SearchResult] = []
                    searchResult.append(contentsOf: result.artists.items.compactMap({.artist(model: $0)}))
                    searchResult.append(contentsOf: result.albums.items.compactMap({.album(model: $0)}))
                    searchResult.append(contentsOf: result.tracks.items.compactMap({.track(model: $0)}))
                    searchResult.append(contentsOf: result.playlists.items.compactMap({.playlist(model: $0)}))
                    
                    completion(.success(searchResult))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
        
    
    //MARK: -Private
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    private func createRequest(with url: URL?,type: HTTPMethod, completion: @escaping (URLRequest) -> Void){
        AuthManagaer.shared.withValidToken { token in
            guard let apiURL = url else {return}
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
