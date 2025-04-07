//
//  CustomView.swift
//  IosAppChnageIcon
//
//  Created by Wilton Garcia on 07/04/25.
//

import UIKit
import UIKit

class CustomView: UIViewController {
    
    // MARK: - Configuração dos Ícones
    private let iconNames = [
        "AppIcon-Backpack",
        "AppIcon-Camera",
        "AppIcon-Campfire",
        "AppIcon-MagnifyingGlass",
        "AppIcon-Map",
        "AppIcon-Mushroom"
    ]
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Meus Ícones Personalizados"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(IconCell.self, forCellWithReuseIdentifier: IconCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        verifyIcons()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Verificação dos Ícones
    private func verifyIcons() {
        for name in iconNames {
            if UIImage(named: name) == nil {
                print("⚠️ Ícone não encontrado: \(name)")
            } else {
                print("✅ Ícone carregado: \(name)")
            }
        }
    }
}

// MARK: - CollectionView DataSource & Delegate
extension CustomView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCell.identifier, for: indexPath) as! IconCell
        cell.configure(with: iconNames[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 60) / 3
        return CGSize(width: width, height: width)
    }
}

// MARK: - Célula Personalizada para Ícones
class IconCell: UICollectionViewCell {
    static let identifier = "IconCell"
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(iconImageView)
        iconImageView.frame = contentView.bounds
    }
    
    func configure(with iconName: String) {
        // Carrega a imagem SEM o modo template
        if let icon = UIImage(named: iconName)?.withRenderingMode(.alwaysOriginal) {
            iconImageView.image = icon
            iconImageView.tintColor = nil // Remove qualquer tintura
        } else {
            // Fallback visual claro
            iconImageView.image = UIImage(systemName: "exclamationmark.triangle")?
                .withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = .systemRed
        }
    }
}
