//
//  CommunityDetails.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 15/01/23.
//

import SwiftUI

struct CommunityDetails: View {
    @State var community : String
    @State var names = ""
    @State var members : [String]
    var body: some View {
        VStack{
            HStack
            {
                Image(systemName: "person.3")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                Text(community)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
            }
            .padding(.bottom,1)
           
            Text(names)
                        .font(.caption)
                        .foregroundColor(.gray)
                
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
        .onAppear()
        {
            let count = members.count
            var i = 0
            while (i < count)
            {
                names = names + members[i]
                if (i != count - 1)
                {
                    names = names + ", "
                }
                i += 1
            }
        }
    }
        
}

struct CommunityDetails_Previews: PreviewProvider {
    static var previews: some View {
        CommunityDetails(community: "", members: [""])
    }
}
