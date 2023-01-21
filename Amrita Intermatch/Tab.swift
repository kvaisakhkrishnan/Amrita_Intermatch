//
//  Tab.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 10/11/22.
//

import SwiftUI

struct Tab: View {
    @State var email : String
    @State var tags : [String]
    @State var typ : String
    @State var github : String
    @State var aboutMe : String
    @State var name : String
    @State var role : String
    @State var linkedin : String
    @State var resume : String
    
    
    var body: some View {
        
        
        TabView
        {
            
            Reccomendation(tag: tags, email: email)
                .tabItem {
                    Label("Recommendation", systemImage: "hand.thumbsup.fill")
                }
            
            Search()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            if(typ == "Faculty"){
                AddButton(email: email)
                    .tabItem {
                        Label("Add", systemImage: "plus")
                    }
                
                
              
            }
            else
            {
                Ideas(email: email)
                    .tabItem {
                        Label("Idea", systemImage: "lightbulb")
                    }
            }
            
            
           
            
            
            Likes(email: email)
                .tabItem {
                    Label("Likes", systemImage: "heart")
                }
            
            Profile(aboutMe: aboutMe,name: name, role: role, email: email, github: github, Linkedin: linkedin, Resume: resume, tags: tags)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            
            
           
            
            
            
            
        }
        
        
    }
}

struct Tab_Previews: PreviewProvider {
    static var previews: some View {
        Tab(email: "", tags: [""], typ: "", github: "", aboutMe: "", name: "", role: "", linkedin: "", resume: "")
    }
}
