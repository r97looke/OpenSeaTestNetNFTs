//
//  NFTDetailsViewController.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/2.
//

import UIKit
import SnapKit
import SDWebImage
import RxSwift
import RxCocoa

final class NFTDetailsViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let model: NFTInfoModel
    private let disposeBag = DisposeBag()
    
    init(model: NFTInfoModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    private let DefaultMargin = 16.0
    private let DefaultSpace = 8.0
    
    private let safeAreaView = UIView()
    private let scrollView = UIScrollView()
    private let vStack = UIStackView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let permalinkButton = UIButton(type: .roundedRect)
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(safeAreaView)
        safeAreaView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isDirectionalLockEnabled = true
        
        permalinkButton.translatesAutoresizingMaskIntoConstraints = false
        permalinkButton.setTitle("permalink", for: .normal)
        permalinkButton.setTitleColor(.blue, for: .normal)
        permalinkButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            
            self.openPermalink()
        }.disposed(by: disposeBag)
        
        safeAreaView.addSubview(scrollView)
        safeAreaView.addSubview(permalinkButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(DefaultMargin)
            make.leading.equalToSuperview().offset(DefaultMargin)
            make.trailing.equalToSuperview().offset(-DefaultMargin)
        }
        
        permalinkButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(DefaultSpace)
            make.leading.equalToSuperview().offset(DefaultMargin)
            make.trailing.equalToSuperview().offset(-DefaultMargin)
            make.bottom.equalToSuperview().offset(-DefaultMargin)
        }
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = DefaultSpace
        vStack.alignment = .fill
        vStack.distribution = .fill
        scrollView.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(nameLabel)
        vStack.addArrangedSubview(descriptionLabel)
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width).multipliedBy(1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = model.collection
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        if let image_url = model.image_url, let imageURL = URL(string: image_url) {
            imageView.sd_setImage(with: imageURL) { [weak self] image, error, _, _ in
                guard let self = self else { return }
                
                if let image = image {
                    let width = image.size.width
                    let height = image.size.height
                    if width > 0, height > 0 {
                        self.imageView.snp.remakeConstraints { make in
                            make.height.equalTo(self.imageView.snp.width).multipliedBy(height/width)
                        }
                    }
                }
            }
        }
    }
    
    private func openPermalink() {
        if UIApplication.shared.canOpenURL(model.permalink()) {
            UIApplication.shared.open(model.permalink())
        }
    }

}

// MARK: Helpers
private extension NFTInfoModel {
    func permalink() -> URL {
        return URL(string: "https://testnets.opensea.io/assets/goerli/\(contract)/\(identifier)")!
    }
}
