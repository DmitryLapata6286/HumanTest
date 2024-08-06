//
//  TabBarCoordinator.swift
//  HumanTest
//

import UIKit

protocol TabBarCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
    
}
 
final class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorOutput {
    private typealias Flow = (Coordinatable, Presentable)
  
    var finishFlow: CompletionBlock?
    var tabBarController: TabBarController = .init()
    
    fileprivate let router : Routable
    
    init(router: Routable) {
        self.router  = router
    }
    
    override func start() {
        performFlow()
    }
}

extension TabBarCoordinator: Coordinatable {}

extension TabBarCoordinator: TabCoordinatorProtocol {
    func selectPage(_ page: TabBarItem) {
        tabBarController.selectedIndex = page.pageIndex
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarItem.init(rawValue: index) else { return }
        tabBarController.selectedIndex = page.pageIndex
    }
    
    func currentPage() -> TabBarItem? {
        TabBarItem.init(rawValue: tabBarController.selectedIndex)
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }
}
 
// MARK:- Private methods
private extension TabBarCoordinator {
    func performFlow() {
        let pages: [TabBarItem] = TabBarItem.allCases
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarItem.editor.pageIndex
        tabBarController.tabBar.isTranslucent = false
        
        router.setRootModule(tabBarController, hideBar: true)
    }
    
    func configureAppearence() {

    }

    func getTabController(_ page: TabBarItem) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        let item = UITabBarItem(title: page.title,
                                image: page.icon.withRenderingMode(.alwaysTemplate),
                                tag: page.pageIndex)
        navController.tabBarItem = item
        let vc: UIViewController = switch page {
            case .editor:       configureEditorController()
            case .settings:     configureSettingsController()
        }
        navController.pushViewController(vc, animated: true)
        return navController
    }
}

// Build VCs
private extension TabBarCoordinator {
    func configureEditorController() -> UIViewController {
        let vc = EditorViewController()
        return vc
    }
    
    func configureSettingsController() -> UIViewController {
        let vc = SettingsViewController()
        return vc
    }
    
}
