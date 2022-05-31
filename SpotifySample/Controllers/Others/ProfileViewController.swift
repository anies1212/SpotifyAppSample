//
//  ProfileViewController.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/02.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.isHidden = true
        return table
    }()
    
    private var models = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        fetchProfile()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    private func fetchProfile(){
        APICaller.shared.getCurrentUserProfile {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                case .failure(let error):
                    self?.failedToGetProfile()
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI(with model: UserProfile){
        tableView.isHidden = false
        models.append("User Name: \(model.display_name)")
        models.append("Email: \(model.email)")
        models.append("ID: \(model.id)")
        models.append("Plan: \(model.product)")
        createTableHeader(with: model.images.first?.url)
        tableView.reloadData()
    }
    
    private func createTableHeader(with string: String?){
        guard let urlString = string, let url = URL(string: urlString) else {return}
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        let imageSize: CGFloat = headerView.height/1.2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.layer.cornerRadius = imageView.width/2
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.sd_setImage(with: url, completed: nil)
        tableView.tableHeaderView = headerView
    }
    
    private func failedToGetProfile(){
        let label = UILabel(frame: .zero)
        label.text = "Failed to get Profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }


}

//MARK: -TableView
extension ProfileViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Your User Profile"
        default:
            break
        }
        return ""
    }
    
    
}
