//
//  ProgressView.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import UIKit

class ProgressView: UIProgressView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 0)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
        progressTintColor = .darkGray
        trackTintColor = .clear
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        progressViewStyle = .bar
        
    }
    
}
