//
//  Community.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 15/01/23.
//

import SwiftUI

struct Community: View {
    @State var message = ["Poda", "Vere", "Pani ONNM ILLEDA"]
    var body: some View {
       
            ZStack
            {
                VStack
                {
                    CommunityDetails(community: "Community", members: ["Abirami", "K Vaisakh", "Sharath"])
                        .frame(alignment: .top)
                        .padding(.vertical, 3)
                        .shadow(radius: 100)
                    
                    
                    ZStack{
                        
                        Image("back")
                            .resizable()
                            .opacity(0.1)
                          
                        
                        ScrollView{
                            
                            ForEach(message, id:\.self)
                            {
                                data in
                                MessageBubble(user: "cb.en.u4cse", message: data)
                            }
                            
                        }
                    }
                    
                
                
                
            }
                
        }
    }
}

struct Community_Previews: PreviewProvider {
    static var previews: some View {
        Community()
    }
}
