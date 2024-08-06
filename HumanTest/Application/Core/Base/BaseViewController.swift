//
//  BaseViewController.swift
//  HumanTest
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    var cancelables = Set<AnyCancellable>()
}
