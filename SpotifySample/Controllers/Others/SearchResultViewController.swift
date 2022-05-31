//
//  SearchResultViewController.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/02.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultViewControllerDelegate: AnyObject {
    func didTappedResult(_ result: SearchResult)
}

class SearchResultViewController: UIViewController {
    
    weak var delegate: SearchResultViewControllerDelegate?
    private var sections: [SearchSection] = []
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .systemBackground
        table.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        table.register(SearchResultSubTitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubTitleTableViewCell.identifier)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results: [SearchResult]){
        let artists = results.filter({
            switch $0 {
            case .artist:
                return true
            default:
                return false
            }
        })
        let albums = results.filter({
            switch $0 {
            case .album:
                return true
            default:
                return false
            }
        })
        let tracks = results.filter({
            switch $0 {
            case .track:
                return true
            default:
                return false
            }
        })
        let playlists = results.filter({
            switch $0 {
            case .playlist:
                return true
            default:
                return false
            }
        })
        self.sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Album", results: albums)
        ]
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }

}
extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultDefaultTableViewCellViewModel(title: artist.name, imageURL: URL(string: artist.images?.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
            
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as? SearchResultSubTitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubTitleTableViewCellViewModel(title: album.name, imageURL: URL(string: album.images.first?.url ?? ""), subTitle: album.artists.first?.name ?? "")
            cell.configure(with: viewModel)
            return cell
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as? SearchResultSubTitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubTitleTableViewCellViewModel(title: playlist.name, imageURL: URL(string: playlist.images.first?.url ?? ""), subTitle: playlist.owner.display_name)
            cell.configure(with: viewModel)
            return cell
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as? SearchResultSubTitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubTitleTableViewCellViewModel(title: track.name, imageURL: URL(string: track.album?.images.first?.url ?? ""), subTitle: track.artists.first?.name ?? "")
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTappedResult(result)
    }
}
