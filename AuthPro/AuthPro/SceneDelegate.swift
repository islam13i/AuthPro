//
//  SceneDelegate.swift
//  AuthPro
//
//  Created by Islam on 4/4/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import Firebase
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Auth.auth().addStateDidChangeListener{ (auth, user) in
            if user == nil {
                self.showModalAuth()
            }else{
                self.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    func showModalAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newvc = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        newvc.modalPresentationStyle = .fullScreen
        newvc.modalTransitionStyle = .crossDissolve
        self.window?.rootViewController?.present(newvc, animated: true, completion: .none)
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

