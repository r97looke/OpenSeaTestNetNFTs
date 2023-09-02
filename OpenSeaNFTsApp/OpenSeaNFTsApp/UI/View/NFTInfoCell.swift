//
//  NFTInfoCell.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/2.
//

import UIKit
import SnapKit
import SDWebImage

class NFTInfoCell: UICollectionViewCell {
    
    static let DefaultSize = CGSize(width: 176, height: 208)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let DefaultSpace: CGFloat = 8.0
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView = nil
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.blue.cgColor
        
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(DefaultSpace)
            make.leading.equalToSuperview().offset(DefaultSpace)
            make.trailing.equalToSuperview().offset(-DefaultSpace)
            make.height.equalTo(160)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(DefaultSpace)
            make.leading.equalToSuperview().offset(DefaultSpace)
            make.trailing.equalToSuperview().offset(-DefaultSpace)
        }
    }
    
    var model: NFTInfoModel? {
        didSet {
            if let model = model {
                nameLabel.text = model.name
                if let image_url = model.image_url, let imageURL = URL(string: image_url) {
                    imageView.sd_setImage(with: imageURL)
                }
                else {
                    imageView.image = nil
                }
            }
            else {
                nameLabel.text = nil
                imageView.image = nil
                imageView.sd_cancelCurrentImageLoad()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        imageView.image = nil
        imageView.sd_cancelCurrentImageLoad()
    }
}
