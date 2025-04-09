//
//  ViewController.swift
//  IosChangeAppIcon
//
//  Created by Wilton Garcia on 08/04/25.
//



import UIKit

class ViewController: UIViewController {
    
    let imageNames = ["AppIcon-MagnifyingGlass",
                      "AppIcon-Map",
                      "AppIcon-Mushroom",
                      "AppIcon-Camera",
                      "AppIcon-Backpack",
                      "AppIcon-Campfire"
    ]
    
    private lazy var blankViewControllerTransitioningDelegate = BlankViewControllerTransitioningDelegate()

    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Change App Icon - UIKit"
        label.textColor = .label
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Click to change Icon"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var showAlertLabel: UILabel = {
        let label = UILabel()
        label.text = "Show Alert"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var showAlertSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false

        return switchControl
    }()
    
    
    private lazy var changeScreenButton: UIButton = {
       let button = UIButton()
        button.setTitle("Next Screen", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(navigateNextSceen), for: .touchUpInside)
        return button
    }()
    
    
    // Lazy initialization of the UICollectionView
    private lazy var mainCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(DemoCollectionViewCell.self, forCellWithReuseIdentifier: DemoCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupView()
    }
    
    // Method to reload the collection view on the main thread
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.mainCollectionView.reloadData()
        }
    }
    
    @objc func navigateNextSceen() {
        let nextViewController = ApiViewController()
        print("Call other view Controller")
        self.present(nextViewController, animated: true)
        
        
    }
    
    // Setup the view and add collection view with constraints
    private func setupView() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        view.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        view.addSubview(showAlertLabel)
        NSLayoutConstraint.activate([
            showAlertLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            showAlertLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
        ])
        
        view.addSubview(showAlertSwitch)
        NSLayoutConstraint.activate([
            showAlertSwitch.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            showAlertSwitch.leadingAnchor.constraint(equalTo: showAlertLabel.leadingAnchor, constant: 190),
            showAlertSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        view.addSubview(changeScreenButton)
        NSLayoutConstraint.activate([
            changeScreenButton.topAnchor.constraint(equalTo: showAlertSwitch.safeAreaLayoutGuide.topAnchor, constant: 50),
            changeScreenButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            changeScreenButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            changeScreenButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(mainCollectionView)
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: changeScreenButton.safeAreaLayoutGuide.bottomAnchor, constant: 50),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Return the number of items in the collection view section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    // Configure and return the cell for a given index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DemoCollectionViewCell.identifier, for: indexPath) as! DemoCollectionViewCell
        cell.configure(with: imageNames[indexPath.row])
        
        return cell
    }
    
    // Return the size for the item at a given index path
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100 , height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Will change icon image to \(imageNames[indexPath.row])")
        
        if showAlertSwitch.isOn {
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName(imageNames[indexPath.row]) { error in
                    if let error = error {
                        print("Erro detalhado: \(error)")
                    } else {
                        print("Sem error")
                    }
                }
            }
        } else {
          
                if UIApplication.shared.supportsAlternateIcons {
                    let blankViewController = UIViewController()
                    blankViewController.modalPresentationStyle = .custom
                    blankViewController.transitioningDelegate = blankViewControllerTransitioningDelegate
                    present(blankViewController, animated: false, completion: { [weak self] in
                        UIApplication.shared.setAlternateIconName(self!.imageNames[indexPath.row])
                        self?.dismiss(animated: false, completion: nil)
                    })
                
            }
        }
        
  
    }
}
