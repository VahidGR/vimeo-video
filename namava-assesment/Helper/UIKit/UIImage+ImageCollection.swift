//
//  UIImage+ImageCollection.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import UIKit

extension UIImage {
    
    
    convenience init!(systemImage: ImageCollection) {
        self.init(systemName: systemImage.rawValue)
    }
    
    
}
