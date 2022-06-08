//
//  WelcomeViewController.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/02.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemGreen
        return button
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "albums_background")
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let image = UIImage(named: "Logo")
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textAlignment = .center
        label.text = "Listen to Millions \nof the Songs."
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemBackground
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.addSubview(logoImageView)
        view.addSubview(label)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTappedSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 20, y: (view.height - 50) - view.safeAreaInsets.bottom, width: view.width - 40, height: 50)
        logoImageView.frame = CGRect(x: (view.width-200)/2, y: (view.height-350)/2, width: 200, height: 200)
        label.frame = CGRect(x: 0, y: logoImageView.bottom + 5, width: view.width, height: 200)
        backgroundImageView.frame = view.bounds
        overlayView.frame = view.bounds
    }
    
    @objc func didTappedSignIn(){
        let vc = AuthViewController()
        vc.completionHandler = {[weak self] success in
            guard let strongSelf = self else {return}
            DispatchQueue.main.async {
                strongSelf.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    ///LogUserIn
    private func handleSignIn(success: Bool){
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when sign in.", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let mainAppTapbarVC = TabBarViewController()
        mainAppTapbarVC.modalPresentationStyle = .fullScreen
        present(mainAppTapbarVC, animated: true, completion: nil)
    }

}
