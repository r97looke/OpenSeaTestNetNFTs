//
//  SceneDelegate.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import UIKit
import OpenSeaNFTs

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient()
    }()
    
    private lazy var nftLoader: NFTsLoader = {
        let url = OpenSeaNFTsAppSettings.nftsEndpointURL()
        return RemoteNFTsLoader(url: url, client: httpClient)
    }()
    
    private lazy var ethBalanceLoader: ETHBalanceLoader = {
        let ethBalanceURL = OpenSeaNFTsAppSettings.ethBalanceEndpointURL()
        return RemoteETHBalanceLoader(url: ethBalanceURL,
                                      address:  OpenSeaNFTsAppSettings.account(),
                                      client: httpClient)
    }()

    private lazy var navigationController: UINavigationController = {
        return UINavigationController(
            rootViewController: NFTListComposer.compose(nftLoader: nftLoader,
                                                        ethBalanceLoader: ethBalanceLoader,
                                                        selection: showDetail))
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func showDetail(_ model: NFTInfoModel) {
        let detailVC = NFTDetailComposer.compose(model: model, permalinkSelection: openPermalink)
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    private func openPermalink(_ model: NFTInfoModel) {
        if UIApplication.shared.canOpenURL(model.permalinkURL) {
            UIApplication.shared.open(model.permalinkURL)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

// MARK: Helpers
private extension NFTInfoModel {
    var permalinkURL: URL {
        return URL(string: "\(OpenSeaNFTsAppSettings.permalinkBase())/\(contract)/\(identifier)")!
    }
}

