//
//  LibraryToggleView.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/05/09.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToggleViewDidTappedPlaylist(_ toggleView: LibraryToggleView)
    func libraryToggleViewDidTappedAlbum(_ toggleView: LibraryToggleView)

}

class LibraryToggleView: UIView {
    
    enum State {
        case playlist
        case album
    }
    
    var state: State = .playlist
    
    private let playListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Playlist", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    weak var delegate : LibraryToggleViewDelegate?
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Albums", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playListButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        playListButton.addTarget(self, action: #selector(didTappedPlaylist), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTappedAlumsList), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playListButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        albumsButton.frame = CGRect(x: playListButton.right, y: 0, width: 100, height: 40)
        layoutIndicator()
    }
    
    @objc func didTappedPlaylist(){
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.libraryToggleViewDidTappedPlaylist(self)
    }
    
    @objc func didTappedAlumsList(){
        state = .album
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.libraryToggleViewDidTappedAlbum(self)
    }
    
    func layoutIndicator(){
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(x: 0, y: playListButton.bottom, width: 100, height: 3)
        case .album:
            indicatorView.frame = CGRect(x: 100, y: albumsButton.bottom, width: 100, height: 3)
        }
    }
    
    func update(for state: State){
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
    

}
