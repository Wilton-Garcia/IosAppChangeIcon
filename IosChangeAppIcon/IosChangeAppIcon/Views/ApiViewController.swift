//
//  ApiViewController.swift
//  IosChangeAppIcon
//
//  Created by Wilton Garcia on 08/04/25.
//
import UIKit
import Foundation

class ApiViewController: UIViewController {
    
    var notifyIconChance: Bool = true
    let apiController = AppController()
    private lazy var blankViewControllerTransitioningDelegate = BlankViewControllerTransitioningDelegate()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
        
        setupView()
        requestFromApi()
    }
    
    func requestFromApi() {
        DispatchQueue.main.async{
            self.apiController.getInitialConfig { iconName in
                if self.notifyIconChance {
                    
                    UIApplication.shared.setAlternateIconName(iconName) { error in
                        print("The icon was changed for \(iconName)")
                        
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                        
                    }
                    
                } else {
                    if UIApplication.shared.supportsAlternateIcons {
                        let blankViewController = UIViewController()
                        blankViewController.modalPresentationStyle = .custom
                        blankViewController.transitioningDelegate = self.blankViewControllerTransitioningDelegate
                        self.present(blankViewController, animated: false, completion: {
                            UIApplication.shared.setAlternateIconName(iconName)
                            self.dismiss(animated: false, completion: nil)
                        })
                        
                    }
                }
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "The icon was changed"
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupView() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    
}
