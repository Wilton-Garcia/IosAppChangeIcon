//
//  ContentView.swift
//  IosChangeAppIcon-SwiftUI
//
//  Created by Wilton Garcia on 08/04/25.
//

import SwiftUI

struct AppIconChangerView: View {
    let imageNames = [
        "AppIcon-MagnifyingGlass",
        "AppIcon-Map",
        "AppIcon-Mushroom",
        "AppIcon-Camera",
        "AppIcon-Backpack",
        "AppIcon-Campfire"
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            Text("Change App Icon - SwiftUI")
                .font(.system(size: 32, weight: .bold))
                .padding(.top)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(imageNames, id: \.self) { name in
                    IconCell(imageName: name)
                        .onTapGesture {
                            changeAppIcon(to: name)
                        }
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
        }
        .background(Color.white)
    }
    
    func changeAppIcon(to name: String) {
        guard UIApplication.shared.supportsAlternateIcons else {
            print("App não suporta trocas de ícones")
            return }
        
        let iconName = name == "AppIcon" ? nil : name.replacingOccurrences(of: "-Preview", with: "")
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("Erro detalhado: \(error.localizedDescription)")
            } else {
                print("Ícone alterado para: \(String(describing: iconName))")
            }
        }
    }
}

struct IconCell: View {
    let imageName: String
    
    var body: some View {
        Image("\(imageName)-Preview")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)
    }
}


#Preview {
    AppIconChangerView()
}
