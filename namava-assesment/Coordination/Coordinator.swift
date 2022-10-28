//
//  Coordinator.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/25/22.
//

import UIKit
import RxSwift
import RxFlow

class Coordinator: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(false, animated: false)
        return viewController
    }()
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {

        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .authenticaed(let valid):
            return navigateToListScreen(authenticated: valid)
        case .showDetails(let video):
            return navigateToDetailsScreen(video: video)
        }
        
    }
    
    private func navigateOrInitiate(viewController: UIViewController) {
        if rootViewController.viewControllers.isEmpty {
            self.rootViewController.setViewControllers([viewController], animated: false)
        }
        else
        {
            self.rootViewController.pushViewController(viewController, animated: true)
        }
    }

    private func navigateToListScreen(authenticated: Bool) -> FlowContributors {
        let viewController = ListViewController()
        if authenticated == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                viewController.presentAlert(message: "Could not authenticate", actionText: "Retry")
            }
        }
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel))
    }
    
    private func navigateToDetailsScreen(video: VideoListData) -> FlowContributors {
        let viewController = DetailViewController()
        viewController.viewModel.video = video
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel))
    }
    
}
