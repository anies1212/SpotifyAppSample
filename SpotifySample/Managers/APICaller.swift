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
    
    public func getCurrentUserAlbum(completion: @escaping (Result<[Album], Error>)->Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/me/albums/?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(LibraryAlbumResponse.self, from: data)
                    completion(.success(result.items.compactMap({$0.album})))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func addAlbumToPlaylist(album: Album, completion: @escaping (Bool)->Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/me/albums?ids=\(album.id)"), type: .PUT) { baseRequest in
            var request = baseRequest
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let code = (response as? HTTPURLResponse)?.statusCode, error == nil else {
                    completion(false)
                    return
                }
                completion(code == 200)
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
    
    public func getCurrentUserPlaylist(completion: @escaping (Result<[Playlist], Error>) -> Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/me/playlists/?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(LibraryPlaylistResponse.self, from: data)
                    completion(.success(result.items))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    public func createPlaylist(with name:String, completion: @escaping(Bool) -> Void){
        getCurrentUserProfile {[weak self] result in
            switch result {
            case .success(let profile):
                let urlString = Constants.baseApiUrl + "/users/\(profile.id)/playlists"
                self?.createRequest(with: URL(string: urlString), type: .POST) { baseRequest in
                    var request = baseRequest
                    let json = ["name":name]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let data = data, error == nil else {
                            return
                        }
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            if let response = result as? [String:Any], response["id"] as? String != nil {
                                print("Created Successfully")
                                completion(true)
                            }
                            completion(false)
                        } catch {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                    task.resume()
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    public func addTrackToPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool)->Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/playlists/\(playlist.id)/tracks"), type: .POST) { baseRequest in
            var request = baseRequest
            let json = ["uris":["spotify:track:\(track.id)"]]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil{
                    completion(true)
                    }
                } catch {
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    public func removeTrackFromPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool)->Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/playlists/\(playlist.id)/tracks"), type: .DELETE) { baseRequest in
            var request = baseRequest
            let json = [
                "tracks":[
                    [
                        "uri":"spotify:track:\(track.id)"
                    ]
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil{
                    completion(true)
                    }
                } catch {
                    completion(false)
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
        case DELETE
        case PUT
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
