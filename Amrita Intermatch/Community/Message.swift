//
//  Message.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 17/01/23.
//

import SwiftUI

struct Message: View {
    @State var message : String = ""
    @State private var offset: CGFloat = 0
   

    var body: some View {
        HStack
        {
            TextField("Enter your message here", text: $message)
                .padding(.leading,10)
                .padding(.vertical,7)
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.leading)
                
                
                
                
            
            Button {
                
            } label: {
                
                
                
                Image(systemName: "paperplane.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
            }
            .padding(.trailing)
        }
    }
}

struct Message_Previews: PreviewProvider {
    static var previews: some View {
        Message()
    }
}
