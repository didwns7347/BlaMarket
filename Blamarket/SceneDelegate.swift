//
//  SceneDelegate.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/17.
//

import UIKit
enum MainVC {
    case loginVC
    case boardVC
    case testVC
}
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var loginVM = LoginViewModel()
    var mainVM = MainViewModel()
    //TEST
    var registVM = RegistItemViewModel()
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
   
        switch self.selectMainView(){
        case .loginVC:
            let rootViewController = LoginViewController()
            rootViewController.bind(vm: loginVM)
            window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        case .boardVC:
            let tbc = UITabBarController()
            
            let mainVC = MainViewController()
            mainVC.bind(vm: mainVM)
            let chatVC = ChatListViewController()
            let userInfoVC = UserInfoViewConroller()
            

            let imgSize = CGSize(width: 30, height: 30)
            mainVC.tabBarItem = UITabBarItem(title: "게시판",image:UIImage(named: "047-house.png")!.imageResized(to:imgSize),tag: 0)
            chatVC.tabBarItem = UITabBarItem(title: "채팅", image:UIImage(named: "098-message.png")!.imageResized(to: imgSize), tag: 0)
            userInfoVC.tabBarItem = UITabBarItem(title: "내 정보", image: UIImage(named:"011-user.png")!.imageResized(to: imgSize), tag: 0)
            tbc.setViewControllers([chatVC,UINavigationController(rootViewController: mainVC),userInfoVC], animated: false)
            tbc.selectedIndex = 1
            
          
            window?.rootViewController = tbc
        default:
            let rootViewController = LoginViewController()
            rootViewController.bind(vm: loginVM)
            window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        }
      
//        let rootViewController = RegistItemViewController()
//        rootViewController.bind(viewModel: registVM)
        window?.backgroundColor = .systemBackground
       
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

extension SceneDelegate{
    func selectMainView() -> MainVC{
        #if DEBUG
        return MainVC.boardVC
        #endif
        if isAutoLoginAvailable(){
            return MainVC.boardVC
        }else{
            return MainVC.loginVC
        }
    }
    
    func isAutoLoginAvailable()->Bool{
        guard let lastLoginDate = UserDefaults.standard.object(forKey: UserConst.LAST_LOGIN_DATE) as? Date
        else{
            return false
        }
        
        var dateComponentDay = DateComponents()
        dateComponentDay.day = UserConst.Login_Alive_Time
        let expireDate = Calendar.current.date(byAdding: dateComponentDay, to: lastLoginDate) ?? Date()
        //만료된경우 토큰값 삭제.
        if expireDate <= Date(){
            KeyChainManager.removedataInKeyChain(key: UserConst.Authorize_key)
            return false
        }
        return true
    }

}
