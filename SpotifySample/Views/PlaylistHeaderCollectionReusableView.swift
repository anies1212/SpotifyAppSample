//
//  PlaylistHeaderCollectionReusableView.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/14.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDidTappedPlayAllButton(_header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate:PlaylistHeaderCollectionReusableViewDelegate?
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    private let ownerLabel: UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private let playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    //MARK: -Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(playlistImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTappedPlayAllButton), for: .touchUpInside)
    }
    
    func configure(with viewModel: PlaylistHeaderViewModels){
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        ownerLabel.text = viewModel.ownerName
        playlistImageView.sd_setImage(with: viewModel.artWorkURL, completed: nil)
    }
    
    @objc func didTappedPlayAllButton(){
        delegate?.playlistHeaderCollectionReusableViewDidTappedPlayAllButton(_header: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = height/1.8
        playlistImageView.frame = CGRect(x: (width-imageSize)/2, y: 20, width: imageSize, height: imageSize)
        nameLabel.frame = CGRect(x: 10, y: playlistImageView.bottom, width: width - 20 , height: 44)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: width-20, height: 44)
        ownerLabel.frame = CGRect(x: 10, y: descriptionLabel.bottom, width: width-20, height: 44)
        playAllButton.frame = CGRect(x: width-80, y: height-80, width: 60, height: 60)
    }
    
}
