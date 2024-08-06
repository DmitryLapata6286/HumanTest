//
//  Coordinatable.swift
//  HumanTest
//

import UIKit

protocol Coordinatable: AnyObject {
    func start()
}
 
protocol Presentable {
    var toPresent: UIViewController? { get }
}
 
extension UIViewController: Presentable {
    var toPresent: UIViewController? {
        return self
    }
    
    func showAlert(title: String, message: String? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: completion)
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
