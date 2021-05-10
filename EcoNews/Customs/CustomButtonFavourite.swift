//
//  CustomButtonFavourite.swift
//  EcoHelper
//
//  Created by Никита Ткаченко on 01.05.2021.
//

import Foundation
import UIKit

class CustomButtonFavourite: UIButton {
    var color: UIColor = .black
    let touchDownAlpha: CGFloat = 0.3
    weak var timer: Timer?
    let timerStep: TimeInterval = 0.01
    let animateTime: TimeInterval = 0.4
    lazy var alphaStep: CGFloat = {
        return (1 - touchDownAlpha) / CGFloat(animateTime / timerStep)
    }()
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    deinit {
        stopTimer()
    }
    func setup() {
        backgroundColor = .clear
        layer.backgroundColor = color.cgColor
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if let backgroundColor = backgroundColor {
            color = backgroundColor
        }
        setup()
    }
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                touchDown()
            } else {
                cancelTracking(with: nil)
                touchUp()
            }
        }
    }
    func touchDown() {
        stopTimer()
        layer.backgroundColor = color.withAlphaComponent(touchDownAlpha).cgColor
    }
    
    func touchUp() {
        timer = Timer.scheduledTimer(timeInterval: timerStep,
                                     target: self,
                                     selector: #selector(animation),
                                     userInfo: nil,
                                     repeats: true)
    }
    @objc func animation() {
        guard let backgroundAlpha = layer.backgroundColor?.alpha else {
            stopTimer()
            return
        }
        
        let newAlpha = backgroundAlpha + alphaStep
        
        if newAlpha < 1 {
            layer.backgroundColor = color.withAlphaComponent(newAlpha).cgColor
        } else {
            layer.backgroundColor = color.cgColor
            
            stopTimer()
        }
    }
    
    
}

