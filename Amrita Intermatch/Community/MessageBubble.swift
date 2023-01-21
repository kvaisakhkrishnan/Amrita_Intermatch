//
//  MessageBubble.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 15/01/23.
//

import SwiftUI

struct MessageBubble: View {
    @AppStorage("skip_user") var skip_user = ""
    @State var user : String
    @State var message : String
    var body: some View {
        
        if(user == skip_user)
        {
            HStack{
                Spacer()
                Text(message)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                    .cornerRadius(40)
                    .padding(.trailing)
            }
        }
        else
        {
            HStack{
                Text(message)
                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                    .padding()
                    .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                    .cornerRadius(40)
                    .padding(.leading)
                Spacer()
            }
              
        }
        
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(user: "kvaisakh", message: "Hello World!")
    }
}
