//
//  CellCollectionView.swift
//  IosChangeAppIcon
//
//  Created by Wilton Garcia on 08/04/25.
//

import UIKit

class DemoCollectionViewCell: UICollectionViewCell {
    static let identifier = "DemoCollectionViewCell"
    
    // Lazy initialization of the UIImageView
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure the cell with the image name
    func configure(with imageName: String) {
        imageView.image = UIImage(named: "\(imageName)-Preview")
    }
    
    // Setup the view and add imageView with constraints
    private func setupView() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5)
        ])
        
        imageView.layer.cornerRadius = 8
    }
}
