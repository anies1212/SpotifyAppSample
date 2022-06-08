//
//  LibraryPlaylistViewController.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/05/09.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {
    
    var playlists = [Playlist]()
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SearchResultSubTitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubTitleTableViewCell.identifier)
        table.isHidden = true
        return table
    }()
    public var selectionHandler: ((Playlist)-> Void)?
    private let noPlayListView = ActionLabelView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        noPlayListView.delegate = self
        noPlayListView.configure(with: ActionLabelViewViewModel(text: "You don't have any Playlists yet.", actionTitle: "Create"))
        fetchPlaylist()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(noPlayListView)
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapClose))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlayListView.frame = CGRect(x: 0, y: 0, width:  150, height: 150)
        noPlayListView.center = view.center
        tableView.frame = view.bounds
    }
    
    @objc func didTapClose(){
        dismiss(animated: true)
    }
    
    private func updateUI(){
        if playlists.isEmpty {
            noPlayListView.isHidden = false
            tableView.isHidden = true
        } else {
            noPlayListView.isHidden = true
            tableView.reloadData()
            tableView.isHidden = false
            
        }
    }
    
    private func fetchPlaylist(){
        APICaller.shared.getCurrentUserPlaylist {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
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

extension LibraryPlaylistViewController : ActionLabelViewDelegate {
    
    func actionLabelViewDidButtonTapped(_ actionView: ActionLabelView) {
        showCreatePlaylistsAlert()
    }
    
    public func showCreatePlaylistsAlert(){
        let alert = UIAlertController(title: "New Playlists", message: "Enter Playlist Name", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Playlist..."
        }
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {return}
            APICaller.shared.createPlaylist(with: text) {[weak self] success in
                if success {
                    HapticsManager.shared.vibrate(for: .success)
                    self?.fetchPlaylist()
                } else {
                    print("Failed to create Playlists.")
                    HapticsManager.shared.vibrate(for: .error)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }
    
}
extension LibraryPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as! SearchResultSubTitleTableViewCell
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultSubTitleTableViewCellViewModel(title: playlist.name, imageURL: URL(string: playlist.images.first?.url ?? ""), subTitle: playlist.owner.display_name))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true)
            return
        }
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
