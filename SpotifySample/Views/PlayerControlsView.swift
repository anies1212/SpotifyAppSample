//
//  PlayerControlsView.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/20.
//

import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewdidTappedPlayPauseButton(_ playControlsView: PlayerControlsView)
    func playerControlsViewdidTappedForwardButton(_ playControlsView: PlayerControlsView)
    func playerControlsViewdidTappedBackwardButton(_ playControlsView: PlayerControlsView)
    func playerControlsView(_ playControlsView: PlayerControlsView, didSlideSlider value: Float)
}

struct PlayerControlsViewViewModel {
    let title: String?
    let subTitle: String?
}

final class PlayerControlsView: UIView {
    
    private var isPlaying = true
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    weak var delegate: PlayerControlsViewDelegate?
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "This is my Song"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subTitleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Drake feat. somebody"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(subTitleLabel)
        addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        clipsToBounds = true
        backButton.addTarget(self, action: #selector(didTappedBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTappedNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTappedPlayPause), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subTitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 50)
        volumeSlider.frame = CGRect(x: 10, y: subTitleLabel.bottom+20, width: width-20, height: 44)
        let buttonSize:CGFloat = 60
        playPauseButton.frame = CGRect(x: (width-buttonSize)/2, y: volumeSlider.bottom+30, width: buttonSize, height: buttonSize)
        backButton.frame = CGRect(x: playPauseButton.left-80-buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        nextButton.frame = CGRect(x: playPauseButton.right+80, y: playPauseButton.top, width: buttonSize, height: buttonSize)
    }
    
    @objc func didSlideSlider(_ slider: UISlider){
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
    
    @objc private func didTappedBack(){
        delegate?.playerControlsViewdidTappedBackwardButton(self)
    }
    
    @objc private func didTappedNext(){
        delegate?.playerControlsViewdidTappedForwardButton(self)
    }
    
    @objc private func didTappedPlayPause(){
        self.isPlaying = !isPlaying
        delegate?.playerControlsViewdidTappedPlayPauseButton(self)
        let pause = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        playPauseButton.setImage(isPlaying ? pause : play , for: .normal)
    }
    
    func configure(with viewModel: PlayerControlsViewViewModel){
        nameLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
    }
    
}

