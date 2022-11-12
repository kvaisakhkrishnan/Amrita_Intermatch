//
//  Tab.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 10/11/22.
//

import SwiftUI

struct Tab: View {
    @State var userName : String
    var body: some View {
        TabView
        {
            
            Profile()
                .tabItem {
                    Label("About", systemImage: "person.2")
                }
            
           
            
            
            Likes(userName: userName)
                .tabItem {
                    Label("Likes", systemImage: "heart")
                }
            
            
           
            
            
            
            
        }
        
    }
}

struct Tab_Previews: PreviewProvider {
    static var previews: some View {
        Tab(userName: "")
    }
}
