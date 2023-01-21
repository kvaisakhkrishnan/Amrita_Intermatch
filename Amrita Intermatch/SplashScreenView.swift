//
//  SplashScreenView.swift
//  Amrita Connect
//
//  Created by Vaisakhkrishnan K on 23/11/22.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
   

    
    
    
    @AppStorage("skip_user") var skip_user = ""
    @AppStorage("skip_password") var skip_password = ""
    
    @State private var size = 1.5
    @State private var opacity = 0.0
    var body: some View {
        
        if isActive
        {
            
            if(skip_user == "" || skip_password == "")
            {
                ContentView()
            }
            else
            {
                Load(email: skip_user)
            }
            
          
               
           

                
        }
        else
        {
            
            VStack
            {
                Image("logo")
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear
                {
                    withAnimation(.easeIn(duration: 1.2))
                    {
                        self.size = 1
                        self.opacity = 1.0
                    }
                    
            
                    
                   
                }
               
               
                
            
               
            }
            .onAppear
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0)
                {
                    self.isActive = true
                }
            }
            
           
            
        }
       
       
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
