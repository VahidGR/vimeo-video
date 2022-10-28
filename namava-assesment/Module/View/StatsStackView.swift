//
//  StatsStackView.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/27/22.
//

import UIKit

class StatsStackView: UIStackView {
    
    func configureStats(plays: Int?, likes: Int?, comments: Int?) -> Bool {
        
        var canAddToSuperview = false // to make sure it's added to superview when data is available
        
        axis = .horizontal
        distribution = .equalSpacing
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let plays = plays {
            let playsItem = StatItem(.play, count: plays)
            addArrangedSubview(playsItem)
            
            NSLayoutConstraint.activate([
                playsItem.widthAnchor.constraint(equalToConstant: 50),
                playsItem.heightAnchor.constraint(equalTo: heightAnchor)
            ])
            
            canAddToSuperview = true
        }
        
        if let likes = likes {
            let likesItem = StatItem(.like, count: likes)
            addArrangedSubview(likesItem)
            
            NSLayoutConstraint.activate([
                likesItem.widthAnchor.constraint(equalToConstant: 50),
                likesItem.heightAnchor.constraint(equalTo: heightAnchor)
            ])
            
            canAddToSuperview = true
        }
        
        if let comments = comments {
            let commentsItem = StatItem(.comment, count: comments)
            addArrangedSubview(commentsItem)
            
            NSLayoutConstraint.activate([
                commentsItem.widthAnchor.constraint(equalToConstant: 50),
                commentsItem.heightAnchor.constraint(equalTo: heightAnchor)
            ])
            
            canAddToSuperview = true
        }
        
        return canAddToSuperview
        
    }
    
    class StatItem: UIStackView {
        let type: StatItemType
        let count: Int
        
        init(_ type: StatItemType, count: Int) {
            self.type = type
            self.count = count
            super.init(frame: .zero)
            setupView()
        }
        
        override init(frame: CGRect) {
            self.type = .none
            self.count = -1
            super.init(frame: frame)
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupView() {
            
            axis = .vertical
            distribution = .fill
            spacing = 0
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            let imageView = UIImageView()
            addArrangedSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: widthAnchor),
                imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.67)
            ])
            
            imageView.image = type.icon?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .darkGray
            imageView.contentMode = .scaleAspectFit
            
            let label = UILabel()
            addArrangedSubview(label)
            
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalTo: widthAnchor),
                label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.34)
            ])
            
            label.font = UIFont.systemFont(ofSize: 9.0)
            label.textAlignment = .center
            label.text = String(count)
            
        }
        
        enum StatItemType {
            case play
            case like
            case comment
            case none
            
            var icon: UIImage? {
                switch self {
                case .play:
                    return UIImage(systemName: "play.circle.fill")
                case .like:
                    return UIImage(systemName: "heart")
                case .comment:
                    return UIImage(systemName: "message")
                case .none:
                    return UIImage(systemName: "nosign")
                }
            }
        }
    }
    
}
