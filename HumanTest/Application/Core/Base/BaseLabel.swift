//
//  BaseLabel.swift
//  HumanTest
//

import UIKit

class BaseLabel: UILabel {
    
    init(text: String = "", color: UIColor = .black, font: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular), textAlignment: NSTextAlignment = .left, numberOfLines: Int = 1, lineBreakMode: NSLineBreakMode = .byTruncatingTail, isScaled: Bool = false, scale: CGFloat = 1.0, isHidden: Bool = false) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = color
        self.font = font
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.lineBreakMode = lineBreakMode
        self.adjustsFontSizeToFitWidth = isScaled
        self.minimumScaleFactor = scale
        self.isHidden = isHidden
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
