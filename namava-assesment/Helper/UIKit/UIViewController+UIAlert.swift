//
//  UIViewController+UIAlert.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import UIKit

extension UIViewController {
    
    func presentAlert(message: String?, actionText: String?, action: (() -> ())? = nil) {
        guard let message = message,
              let actionText = actionText
        else { return }
        
        let defaultAction = UIAlertAction(title: actionText,
                             style: .default) { _ in
            action?()
        }
        
        let alert = UIAlertController(title: "Error",
                                      message: message,
              preferredStyle: .alert)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true)
    }
    
}
