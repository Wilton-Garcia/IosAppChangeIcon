//
//  AppController.swift
//  Hike
//
//  Created by Wilton Garcia on 01/04/25.
//
import Foundation

class AppController {
    
    var appIcon = "AppIcon-MagnifyingGlass"
    
    func getInitialConfig(completion: @escaping (_ iconName: String) -> Void) {
        NetworkManager.shared.get(endoint: .initialConfig) { (result: Result<[InitialConfig], NetworkError>) in
            switch result {
            case .success(let initialConfig):
                completion(initialConfig.first?.appIcon ??  "AppIcon-MagnifyingGlass")
              //  self.appIcon = initialConfig.first?.appIcon ??  "AppIcon-MagnifyingGlass"
            case .failure(let error):
                print( error)
            }
        }
    }
    
    func showAditionalIcon(completion: @escaping (_ iconName: String) -> Void) {
        NetworkManager.shared.get(endoint: .initialConfig) { (result: Result<[InitialConfig], NetworkError>) in
            switch result {
            case .success(let initialConfig):
                completion(initialConfig[1].appIcon)

            case .failure(let error):
                print( error)
            }
        }
    }
}
