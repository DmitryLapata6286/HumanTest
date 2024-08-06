//
//  TabBarCoordinatorProtocol.swift
//  HumanTest
//

import UIKit

protocol TabCoordinatorProtocol: BaseCoordinator {
    var tabBarController: TabBarController { get set }
    func selectPage(_ page: TabBarItem)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarItem?
}
