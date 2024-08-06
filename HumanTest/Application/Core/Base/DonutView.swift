//
//  DonutView.swift
//  HumanTest
//

import UIKit

class DonutView: UIView {
    
    var rectForClearing: CGRect = .zero
    var overallColor: UIColor = .clear
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(overallColor.cgColor)
        context.fill(bounds)
        context.clear(rectForClearing)
    }
}
