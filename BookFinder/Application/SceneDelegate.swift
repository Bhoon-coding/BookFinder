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
        let rootViewController = SearchBookViewController()
        let navigationViewController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }

}

