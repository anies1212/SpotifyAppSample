//
//  LibraryAlbumViewController.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/05/09.
//

import UIKit

class LibraryAlbumViewController: UIViewController {
    
    var albums = [Album]()
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SearchResultSubTitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubTitleTableViewCell.identifier)
        table.isHidden = true
        return table
    }()
    private let noAlbumsListView = ActionLabelView()
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        noAlbumsListView.delegate = self
        noAlbumsListView.configure(with: ActionLabelViewViewModel(text: "You don't have any saved albums yet.", actionTitle: "Browse"))
        fetchAlbums()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(noAlbumsListView)
        observer = NotificationCenter.default.addObserver(forName: .albumSavedNotification, object: nil, queue: .main, using: {[weak self] _ in
            self?.fetchAlbums()
            self?.tableView.reloadData()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsListView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width:  150, height: 150)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    @objc func didTapClose(){
        dismiss(animated: true)
    }
    
    private func updateUI(){
        if albums.isEmpty {
            noAlbumsListView.isHidden = false
            tableView.isHidden = true
        } else {
            noAlbumsListView.isHidden = true
            tableView.reloadData()
            tableView.isHidden = false
        }
    }
    
    private func fetchAlbums(){
        APICaller.shared.getCurrentUserAlbum {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
    }
    
}

extension LibraryAlbumViewController : ActionLabelViewDelegate {
    
    func actionLabelViewDidButtonTapped(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
    
}
extension LibraryAlbumViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as! SearchResultSubTitleTableViewCell
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultSubTitleTableViewCellViewModel(title: album.name, imageURL: URL(string: album.images.first?.url ?? ""), subTitle: album.artists.first?.name ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        let album = albums[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
