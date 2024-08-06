//
//  UIKit+Ex.swift
//  HumanTest
//

import UIKit
import Combine

extension UITableViewCell {
    static var nib: UINib { UINib(nibName: reuseID, bundle: nil) }
    static var reuseID: String { String(describing: self) }
}

extension UIView {
    func addSubviews(_ views: UIView...) { views.forEach({ self.addSubview($0) }) }
}

extension UIView {
    func applyMask(forClearing rectForClearing: CGRect, overallColor: UIColor) {
        let maskLayer = CAShapeLayer()
                    
        let path = UIBezierPath(rect: self.bounds)
        let clearPath = UIBezierPath(rect: rectForClearing)
        path.append(clearPath)
        path.usesEvenOddFillRule = true
        
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        maskLayer.fillColor = overallColor.cgColor
        
        self.layer.mask = nil
        self.layer.mask = maskLayer
    }
}

extension UIControl {
    struct EventPublisher: Publisher {
        typealias Output = Void
        typealias Failure = Never

        let control: UIControl
        let event: UIControl.Event

        func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
            let subscription = EventSubscription(subscriber: subscriber, control: control, event: event)
            subscriber.receive(subscription: subscription)
        }
    }

    class EventSubscription<S: Subscriber>: Subscription where S.Input == Void, S.Failure == Never {
        private var subscriber: S?
        weak private var control: UIControl?
        let event: UIControl.Event

        init(subscriber: S, control: UIControl, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            self.event = event
            control.addTarget(self, action: #selector(eventHandler), for: event)
        }

        func request(_ demand: Subscribers.Demand) { }

        func cancel() {
            control?.removeTarget(self, action: #selector(eventHandler), for: event)
            subscriber = nil
        }

        @objc private func eventHandler() {
            _ = subscriber?.receive(())
        }
    }

    func publisher(for event: UIControl.Event) -> EventPublisher {
        return EventPublisher(control: self, event: event)
    }
}
