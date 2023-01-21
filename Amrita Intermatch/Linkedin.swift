//
//  AboutMe.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 18/11/22.
//

import SwiftUI

struct Linkedin: View {
    @State var linkedin : String
    @State var userName : String
    var body: some View {
        NavigationView {
            VStack{
                
                TextEditor(text: $linkedin)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        
                     
                   
                
                
                    
                    Button {
                        
                    } label: {
                        Text("UPDATE")
                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                            .font(.headline)
                            .padding(.bottom)
                        
                    }
               
                   
               

                
            }
            
                .navigationTitle("Linkedin")
        }
        
        .onAppear(){
            checkAboutMe()
        }
    }
    func checkAboutMe()
    {
        if(linkedin == "")
        {
            linkedin = "Paste your Linkedin link"
        }
    }
        
}

struct Linkedin_Previews: PreviewProvider {
    static var previews: some View {
        Linkedin(linkedin : "", userName : "")
    }
}
