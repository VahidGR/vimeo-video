//
//  VimeoThumbnail.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import UIKit

class VimeoThumbnail: UIView {
    
    
    func setThumbnail(thumbnail: UIImage?, isBroken: Bool = false, duration: String?) {
        
        let imageView = UIImageView()
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        imageView.image = thumbnail
        
        let durationLabel = UILabel()
        addSubview(durationLabel)
        
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            durationLabel.widthAnchor.constraint(equalToConstant: 78),
            durationLabel.heightAnchor.constraint(equalToConstant: 36),
            durationLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            durationLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12)
        ])
        
        durationLabel.textAlignment = .center
        durationLabel.font = UIFont.systemFont(ofSize: 12)
        durationLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        durationLabel.textColor = .white
        durationLabel.text = duration
        
        let playIcon = UIImageView()
        addSubview(playIcon)
        
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playIcon.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25),
            playIcon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25),
            playIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            playIcon.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        playIcon.image = UIImage(systemName: "play.circle.fill")?.withRenderingMode(.alwaysTemplate)
        playIcon.tintColor = .lightGray
        
        if isBroken {
            
            durationLabel.isHidden = true
            playIcon.isHidden = true
            
            let errorLabel = UILabel()
            addSubview(errorLabel)
            
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                errorLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: -60),
                errorLabel.heightAnchor.constraint(equalToConstant: 40),
                errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
            
            errorLabel.backgroundColor = .black.withAlphaComponent(0.6)
            errorLabel.text = "Video URL is broken"
            errorLabel.font = UIFont.systemFont(ofSize: 14.0)
            errorLabel.textAlignment = .center
            errorLabel.textColor = .orange

        }
        
    }
    
}
