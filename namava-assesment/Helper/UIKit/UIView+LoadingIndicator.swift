//
//  UIView+LoadingIndicator.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import UIKit

extension UIView {
    
    func startLoadingIndicator() {
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .darkGray
        spinner.center = center
        
        addSubview(spinner)
        
        spinner.startAnimating()
        
        isUserInteractionEnabled = false
        
    }
    
    func stopLoadingIndicator() {
        
        guard let spinner = subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView else { return }
        
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        
        isUserInteractionEnabled = true
        
    }
    
}
