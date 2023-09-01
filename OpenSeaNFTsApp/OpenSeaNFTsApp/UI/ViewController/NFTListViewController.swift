//
//  NFTListViewController.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import UIKit

final class NFTListViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: NFTListViewModel
    
    init(viewModel: NFTListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .red
        
        title = viewModel.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
