//
//  SceneDelegate.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import UIKit
import OpenSeaNFTs

struct OpenSeaNFTsAppSettings {
    
    private static func chain() -> String {
        return "goerli"
    }
    
    private static func account() -> String {
        return "0x85fD692D2a075908079261F5E351e7fE0267dB02"
    }
    
    private static func endpointURL() -> URL {
        return URL(string: "https://testnets-api.opensea.io/v2")!
    }
    
    static func nftsEndpointURL() -> URL {
        let queryItem = [URLQueryItem(name: "limit", value: "20")]
        let url = endpointURL()
        return url.appendingPathComponent("chain")
            .appendingPathComponent(chain())
            .appendingPathComponent("account")
            .appendingPathComponent(account())
            .appendingPathComponent("nfts")
            .appending(queryItems: queryItem)
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let url = OpenSeaNFTsAppSettings.nftsEndpointURL()
        let client = URLSessionHTTPClient()
        let loader = RemoteNFTsLoader(url: url, client: client)
        let viewModel = NFTListViewModel(loader: loader)
        let viewController = NFTListViewController(viewModel: viewModel)
        let navigationViewController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
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

