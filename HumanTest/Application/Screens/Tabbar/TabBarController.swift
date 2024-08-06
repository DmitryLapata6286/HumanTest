//
//  TabBarViewController.swift
//  HumanTest
//

import UIKit

final class TabBarController: UITabBarController {
    // - UI
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    // - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutTabbar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

// MARK: - Delegate
extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        feedbackGenerator.impactOccurred()
    }
}

// MARK: - Item
private extension TabBarController {
    func layoutTabbar() {

    }
}

// MARK: - Update
private extension TabBarController {
    func updateUI() {
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.lightGray,
                                                          .font: UIFont.systemFont(ofSize: 12)],
                                                         for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.purple,
                                                          .font: UIFont.systemFont(ofSize: 12)],
                                                         for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.lightGray,
                                                          .font: UIFont.systemFont(ofSize: 12)],
                                                         for: .disabled)
        tabBar.unselectedItemTintColor = .lightGray
    }
}

// MARK: - Configure
private extension TabBarController {
    func configure() {
        addDelegate()
        configureTabBar()
    }
    
    func addDelegate() {
        delegate = self
    }
    
    func configureTabBar() {
        tabBar.itemPositioning = .automatic
        tabBar.tintColor = .purple
    }
}
