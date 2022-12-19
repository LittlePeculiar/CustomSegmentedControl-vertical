//
//  SceneDelegate.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

   var window: UIWindow?


   func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      guard let _ = (scene as? UIWindowScene) else { return }
   }

   func sceneDidBecomeActive(_ scene: UIScene) {
      NetworkMonitor.shared.startMonitoring()
   }

   func sceneWillResignActive(_ scene: UIScene) {
      NetworkMonitor.shared.stopMonitoring()
   }

}

