//
//  AppCoordinator.swift
//  HumanTest
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    override func start() {
        showTabFlow()
    }
        
    func showTabFlow() {
        let router = Router(rootController: navigationController)
        let tabCoordinator = TabBarCoordinator(router: router)
        tabCoordinator.start()
        addDependency(tabCoordinator)
    }
    
}
