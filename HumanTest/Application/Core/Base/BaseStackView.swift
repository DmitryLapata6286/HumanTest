//
//  BaseStackView.swift
//  HumanTest
//

import UIKit

final class BaseStackView: UIStackView {
    
    init(distribution: Distribution = .fill,
         axis: NSLayoutConstraint.Axis = .horizontal,
         spacing: CGFloat = 0,
         masksToBounds: Bool = true,
         contentMode: ContentMode = .scaleToFill) {
        super.init(frame: .zero)
        self.distribution = distribution
        self.axis = axis
        self.spacing = spacing
        self.layer.masksToBounds = masksToBounds
        self.contentMode = contentMode
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
