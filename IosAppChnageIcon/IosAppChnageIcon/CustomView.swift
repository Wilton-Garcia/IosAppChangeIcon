//
//  CustomView.swift
//  IosAppChnageIcon
//
//  Created by Wilton Garcia on 07/04/25.
//
import UIKit

class CustomView: UIViewController {
    
    // Dicionário: [Nome visível (imagem) : Nome do ícone alternativo (plist)]
    private let iconData: [String: String] = [
        "Backpack": "AppIcon-Backpack",
        "Camera": "AppIcon-Camera",
        "Campfire": "AppIcon-Campfire",
        "MagnifyingGlass": "AppIcon-MagnifyingGlass",
        "Map": "AppIcon-Map",
        "Mushroom": "AppIcon-Mushroom"
    ]

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        verifyIcons()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func verifyIcons() {
        for key in iconData.keys {
            if UIImage(named: key) == nil {
                print("⚠️ Imagem não encontrada: \(key)")
            } else {
                print("✅ Imagem carregada: \(key)")
            }
        }
    }
}

// MARK: - CollectionView DataSource
extension CustomView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCell.identifier, for: indexPath) as! IconCell
        let iconName = Array(iconData.keys)[indexPath.item]
        cell.configure(with: iconName)
        return cell
    }
}

// MARK: - CollectionView Delegate
extension CustomView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = Array(iconData.keys)[indexPath.item]
        if let plistName = iconData[key] {
            changeAppIcon(to: plistName)
        }
    }
    
    private func changeAppIcon(to iconName: String) {
        guard UIApplication.shared.supportsAlternateIcons else {
            showAlert(title: "Erro", message: "Seu dispositivo não suporta mudança de ícones")
            return
        }
        
        let iconToSet: String? = iconName
        
        UIApplication.shared.setAlternateIconName(iconToSet) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(title: "Erro", message: "Não foi possível mudar o ícone: \(error.localizedDescription)")
                } else {
                    self.showAlert(title: "Sucesso", message: "Ícone alterado com sucesso para: \(iconToSet!) = \(iconName)")
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


class IconCell: UICollectionViewCell {
    static let identifier = "IconCell"
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let iconNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, iconNameLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }
    
    func configure(with iconKey: String) {
        iconNameLabel.text = iconKey
        
        if let icon = UIImage(named: iconKey)?.withRenderingMode(.alwaysOriginal) {
            iconImageView.image = icon
        } else {
            iconImageView.image = UIImage(systemName: "exclamationmark.triangle")?
                .withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = .systemRed
        }
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 3 : 0
            contentView.layer.borderColor = isSelected ? UIColor.systemBlue.cgColor : nil
        }
    }
}
