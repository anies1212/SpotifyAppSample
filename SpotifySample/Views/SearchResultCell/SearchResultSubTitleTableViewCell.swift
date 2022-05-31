//
//  SearchResultSubTitleTableViewCell.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/19.
//

import Foundation
import UIKit
import SDWebImage

class SearchResultSubTitleTableViewCell: UITableViewCell {
    static let identifier = "SearchResultSubTitleTableViewCell"
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    private let subTitleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.addSubview(subTitleLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        let labelHeight = contentView.height/2
        subTitleLabel.frame = CGRect(x: iconImageView.right + 10, y: labelHeight, width: contentView.width - iconImageView.right - 15, height: labelHeight )
        label.frame = CGRect(x: iconImageView.right + 10, y: 0, width: contentView.width - iconImageView.right - 15, height: labelHeight )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        subTitleLabel.text = nil
    }
    
    func configure(with viewModel: SearchResultSubTitleTableViewCellViewModel){
        label.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
}
