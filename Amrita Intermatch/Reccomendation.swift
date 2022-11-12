//
//  Reccomendation.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 10/11/22.
//

import SwiftUI

struct Reccomendation: View {
    var body: some View {
        ScrollView{
            
            VStack{
               
                    
                  
                        
                    VStack{
                        Text("Amrita Intermatch")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding(.top,30)
                        Text("Publisher : K Abirami")
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .foregroundColor(.white)
                    }
                    .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                    .frame(height:.infinity, alignment: .top)
                    .shadow(radius: 20)
                    
                
                
            }
            
        }
        
       
    }
}

struct Reccomendation_Previews: PreviewProvider {
    static var previews: some View {
        Reccomendation()
    }
}
