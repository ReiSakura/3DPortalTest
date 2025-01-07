//
//  NavView.swift
//  RealityKit-UIPortal
//
//  Created by Amanda on 30/12/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI

/// The whole nav bar at the side.
struct NavView: View {
    private let viewOptions = ["FYPLab", "Hive"]
    
    // dictionary mapping areas to views
//    private let viewMapping: [String: AnyView] = [
//        "FYPLab": AnyView(FYPlab()),
//        "Hive": AnyView(Hive()),
//        "FoodArea": AnyView(FoodArea()),
//        "Atrium": AnyView(Atrium())
//    ]
    var body: some View {
            VStack {
                NavigationView {
                    // Logo and Title
                    ScrollView(.vertical){
                        VStack {
                            Image("nyplogo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200.0)
                                .padding(.top)
                            //Text("Nanyang Polytechnic")
                            // .font(.headline)
                        }
                        .padding()
                        // navbar
                        //DropdownMenu() // for Block L
                        //DropdownMenu() // Block A
                        VStack(alignment: .leading, spacing: 10) {
                            // all the blocks in NYP skull
                            // DropdownMenu(title: "Block L", options: viewOptions)
//                            DropdownMenu(title: "Block A", options: ["FoodArea", "Atrium"], viewMapping: viewMapping)
//
                        }
                        Spacer() // Push content to the top
                    }
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding()
                }
        }
    }

}

#Preview {
    NavView()
}
