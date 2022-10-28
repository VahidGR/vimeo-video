//
//  ListItemCell.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/25/22.
//

import UIKit

class ListItemCell: UICollectionViewCell {
    
    // components
    weak var titleLabel: UILabel!
    weak var imageView: UIImageView!
    weak var descriptionLabel: UILabel!
    weak var durationLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.contentMode = .scaleAspectFill
        
        durationLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        durationLabel.textColor = .white
        
        titleLabel.textColor = .darkText
        
        descriptionLabel.textColor = .darkText
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        durationLabel.text = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // add subviews with activated constraints
    private func setupView() {
        
        isAccessibilityElement = true
        
        let imageView = UIImageView()
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        let durationLabel = UILabel()
        contentView.addSubview(durationLabel)
        
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            durationLabel.widthAnchor.constraint(equalToConstant: 56),
            durationLabel.heightAnchor.constraint(equalToConstant: 26),
            durationLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            durationLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -6)
        ])
        
        let titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        let descriptionLabel = UILabel()
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        self.imageView = imageView
        self.durationLabel = durationLabel
        self.titleLabel = titleLabel
        self.descriptionLabel = descriptionLabel
        
        configureComponents()
    }
    
    // configure component attributes
    private func configureComponents() {
        
        imageView.layer.masksToBounds = true
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        
        durationLabel.textAlignment = .center
        durationLabel.font = UIFont.systemFont(ofSize: 10)
        
    }
    
}
