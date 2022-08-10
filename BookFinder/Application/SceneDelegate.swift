//
//  SceneDelegate.swift
//  BookFinder
//
//  Created by BH on 2022/08/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        let networkRequester = NetworkRequester()
        let bookListAPIProvider = BookListAPIProvider(networkRequester: networkRequester)
        let bookImageProvider = BookImageProvider(networkRequester: networkRequester)
        let rootViewController = SearchBookViewController.instantiate(
            with: bookListAPIProvider,
            bookImageProvider
        )
        let navigationViewController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

}

