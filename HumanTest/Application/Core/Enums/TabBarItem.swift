//
//  TabBarItem.swift
//  HumanTest
//

import UIKit

enum TabBarItem: Int, CaseIterable {
    case editor = 0
    case settings
    
    var title: String {
        switch self {
            case .editor:       return "Editor"
            case .settings:     return "Settings"
        }
    }
    
    var pageIndex: Int {
        self.rawValue
    }

    var icon: UIImage {
        switch self {
            case .editor:       return UIImage(systemName: "photo") ?? UIImage()
            case .settings:     return UIImage(systemName: "gear") ?? UIImage()
        }
    }

    var selectedColor: UIColor {
        .purple
    }
    
    var normalColor: UIColor {
        .lightGray
    }
}
