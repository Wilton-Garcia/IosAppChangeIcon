//
//  ApiViewController.swift
//  IosChangeAppIcon
//
//  Created by Wilton Garcia on 08/04/25.
import UIKit

class ApiViewController: UIViewController {
    
    // MARK: - Properties
    
    private let apiController = AppController()
    private let blankViewControllerTransitioningDelegate = BlankViewControllerTransitioningDelegate()
    var notifyIconChange: Bool = true
    
    // MARK: - UI Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "The icon was changed"
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requestFromApi()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .orange
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func requestFromApi() {
            self.apiController.getInitialConfig { [weak self] iconName in
                guard let self = self else { return }
                
                if self.notifyIconChange {
                    self.changeIconWithNotification(iconName: iconName)
                } else {
                    self.changeIconSilently(iconName: iconName)
                }
            }
    }
    
    private func changeIconWithNotification(iconName: String?) {
        DispatchQueue.main.async {
            UIApplication.shared.setAlternateIconName(iconName) { error in
                if let error = error {
                    print("Error changing icon: \(error.localizedDescription)")
                } else {
                    print("The icon was changed to \(iconName ?? "default")")
                }
            }
        }
    }
    
    private func changeIconSilently(iconName: String?) {
        
        guard UIApplication.shared.supportsAlternateIcons else { return }
        
        DispatchQueue.main.async {
            
            let blankViewController = UIViewController()
            blankViewController.modalPresentationStyle = .custom
            blankViewController.transitioningDelegate = self.blankViewControllerTransitioningDelegate
            
            self.present(blankViewController, animated: false) {
                UIApplication.shared.setAlternateIconName(iconName)
                self.dismiss(animated: false)
            }
        }
    }
}
