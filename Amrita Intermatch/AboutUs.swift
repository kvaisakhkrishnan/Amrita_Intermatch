//
//  DeveloperView.swift
//  Amrita Connect
//
//  Created by Vaisakhkrishnan K on 07/06/22.
//

import SwiftUI

struct AboutUs: View {
    @State var count = 0
    var body: some View {
        
        
        ScrollView
        {
           
                
                VStack
                {
                    
                 
                      
                     
        
                   Image("Coding-bro")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                       
                    
                    
                  
                       
                       
                        VStack
                        {
                            Text("Developer Forum")
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                .padding(.bottom,30)
                              
                            
                            HStack(spacing:20)
                            {
                                Image("me")
                                    .resizable()
                                    .frame(width: 130, height: 165, alignment: .center)
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                                VStack
                                {
                                    Text("K VAISAKHKRISHNAN")
                                        .font(.title2)
                                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                        .padding(.bottom,2)
                                    
                                    Text("Hi! I am the developer of this app in iOS. Ping me for any issues related with this application.")
                                }
                            }
                            .padding(.bottom,30)
                           
                            
                            HStack(spacing:20)
                            {
                                
                                   
                                VStack
                                {
                                    Text("SHARATH P")
                                        .font(.title2)
                                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                        .padding(.bottom,2)
                                    Text("Hi! I am the developer of the adroid app. Ping me for any issues related with android application.")
                                    
                                }
                                Image("me")
                                    .resizable()
                                    .frame(width: 130, height: 165, alignment: .center)
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                            }
                            .padding(.bottom,30)
                            
                            
                           
                          
                          
                            
                            
                        }
                            
                    
                      
                    
                        
                    
                        
                }
                
                
                
                
                
            
            
        }
        
        
        
        
       
    }
}

struct AboutUs_Previews: PreviewProvider {
    static var previews: some View {
       AboutUs()
    }
}
