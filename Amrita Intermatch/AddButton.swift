//
//  AddButton.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 16/12/22.
//

import SwiftUI

struct AddButton: View {
    @State var email : String
    var body: some View {
       NavigationView{
            VStack
            {
                Image("2941973")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 40)
                Spacer()
            
               VStack
                {
                    Spacer()
                    
                    NavigationLink {
                        AddTags()
                    } label: {
                        HStack
                        {
                            Image(systemName: "plus")
                            Text("ADD TAGS")
                        }
                        .font(.title3)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 68)
                        
                    }
                    .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                    .foregroundColor(.white)
                    
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                   
                    NavigationLink {
                        AddProject(email: email)
                        
                    } label: {
                        HStack
                        {
                            Image(systemName: "plus")
                            Text("ADD PROJECT")
                        }
                        .font(.title3)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                    }
                    .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    
                    Spacer()
                }
                
                
            }
        }
        
    }
    
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton(email: "")
    }
}
