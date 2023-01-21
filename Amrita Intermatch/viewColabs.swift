//
//  ViewResponses.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 15/12/22.
//

import SwiftUI

struct viewColabs: View {
    @State var pid : String
    @State var people : [String]
    var body: some View {
        List{
            ForEach(people, id:\.self){
                data in
                NavigationLink {
                    selectedProfile(email: data, pid: pid)
                } label: {
                    Text(data)
                }

            }
        }
        .navigationTitle("Requests")
        
    }
}

struct viewColabs_Previews: PreviewProvider {
    static var previews: some View {
        viewColabs(pid: "", people: [""])
    }
}
