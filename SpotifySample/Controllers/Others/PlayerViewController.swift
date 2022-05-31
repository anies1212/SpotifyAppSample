//
//  PlayerViewController.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/02.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate : AnyObject{
    func didTappedPlayPause()
    func didTappedForward()
    func didTappedBackward()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let controlsView = PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(x: 10, y: imageView.bottom+10, width: view.width-20, height: view.height-imageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-15)
    }
    
    private func configureBarButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTappedClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTappedAction))
    }
    
    @objc func didTappedClose(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTappedAction(){
        //Action sheet
    }
    
    func configure(){
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        controlsView.configure(with: PlayerControlsViewViewModel(title: dataSource?.songName, subTitle: dataSource?.songTitle))
    }
    
    func refreshUI(){
        configure()
    }


}



extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlsView(_ playControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func playerControlsViewdidTappedPlayPauseButton(_ playControlsView: PlayerControlsView) {
        delegate?.didTappedPlayPause()
    }

    func playerControlsViewdidTappedForwardButton(_ playControlsView: PlayerControlsView) {
        delegate?.didTappedForward()
    }

    func playerControlsViewdidTappedBackwardButton(_ playControlsView: PlayerControlsView) {
        delegate?.didTappedBackward()
    }
}
