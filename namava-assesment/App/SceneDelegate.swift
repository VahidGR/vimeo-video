//
//  SceneDelegate.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/25/22.
//

import UIKit
import RxSwift
import RxFlow

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let bag = DisposeBag()
    var coordinator = FlowCoordinator()
    let preferencesService = PreferencesService()
    
    lazy var appServices = {
        return AppServices(preferencesService: self.preferencesService)
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        coordinateApp()
    }
    
    private func coordinateApp() {
        
        guard let window = window else { return }
        
        coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: bag)
        
        coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: bag)
        
        let appFlow = Coordinator()
        
        coordinator.coordinate(flow: appFlow, with: AppStepper(withServices: appServices))
        
        Flows.use(appFlow, when: .created) { root in
            window.rootViewController = root
            window.makeKeyAndVisible()
        }
        
        UNUserNotificationCenter.current().delegate = self
        
    }


}

