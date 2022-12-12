//
//  SceneDelegate.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/17.
//

import UIKit
import JWTDecode
enum MainVC {
    case loginVC
    case boardVC
    case testVC
}
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   
    var window: UIWindow?
    var loginVM = LoginViewModel()
    var mainVM = MainViewModel()
    
    let testVM = PostDetailViewModel()
    //TEST
    //var registVM = RegistItemViewModel()
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
            userInfoVC.bind(vm: UserInfoViewModel())
            

            let imgSize = CGSize(width: 30, height: 30)
            mainVC.tabBarItem = UITabBarItem(title: "게시판",image:UIImage(named: "047-house.png")!.imageResized(to:imgSize),tag: 0)
            chatVC.tabBarItem = UITabBarItem(title: "채팅", image:UIImage(named: "098-message.png")!.imageResized(to: imgSize), tag: 0)
            userInfoVC.tabBarItem = UITabBarItem(title: "내 정보", image: UIImage(named:"011-user.png")!.imageResized(to: imgSize), tag: 0)
            tbc.setViewControllers([UINavigationController(rootViewController:  chatVC),
                                    UINavigationController(rootViewController: mainVC),
                                    UINavigationController(rootViewController:  userInfoVC)],
                                   animated: false)
//            let tabTitles = ["게시판","채팅", "내정보"]
            
            tbc.selectedIndex = 1
            
          
            window?.rootViewController = tbc
        default:
            let rootViewController = PostDetailViewController()
            rootViewController.bind(vm: testVM)
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
        if TokenManager.shared.isExpired(){
            TokenManager.shared.updateToken()
        }
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
        do{
            let tokenDecode = try decode(jwt: PostEndPoint.authorization)
            print(tokenDecode)
        }catch
        {
            print(error.localizedDescription)
        }
        print(TokenManager.shared.decode(jwtToken: PostEndPoint.authorization))
        //print(tokenDecode ?? "TOKEN DECODE FAILED")
        return MainVC.boardVC
        #endif
        if TokenManager.shared.readToken() != nil{
            if TokenManager.shared.isExpired(){
                TokenManager.shared.updateToken()
            }
            return MainVC.boardVC
            
        }
        return MainVC.loginVC
        
        
    }
    
  

}
