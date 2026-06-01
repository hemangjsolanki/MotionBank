//
//  ContentView.swift
//  ContentView
//
//  Created by Hemang Solanki on 01/06/26.
//


import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(0)
            
            AppleMapsBottomSheet()
                .tabItem {
                    Label("Activity", systemImage: "list.bullet.rectangle.portrait")
                }
                .tag(1)
            
            HeroTransitionView()
                .tabItem {
                    Label("Cards", systemImage: "creditcard.fill")
                }
                .tag(2)
    
        }
        .accentColor(.blue)
    }
}
