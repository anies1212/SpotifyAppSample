//
//  CategoryCollectionViewCell.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/14.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return imageView
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemPurple,
        .systemGreen,
        .systemOrange,
        .systemYellow,
        .systemRed,
        .darkGray,
        .systemBrown,
        .systemTeal
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: (contentView.width/2)-50, y: 0, width: contentView.width, height: contentView.height)
        label.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width-20, height: contentView.height/2)
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel){
        self.label.text = viewModel.title
        self.imageView.sd_setImage(with: viewModel.artWorkURL, completed: nil)
        contentView.backgroundColor = colors.randomElement()
    }
    
}
