//
//  ViewResponses.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 15/12/22.
//

import SwiftUI

struct ViewResponses: View {
    @State var pname : String
    @State var pid : String
    @State var people : [String]
    var body: some View {
        List{
            ForEach(people, id:\.self){
                data in
                NavigationLink {
                    seeProfile(pname: pname, email: data, pid: pid)
                } label: {
                    Text(data)
                }

            }
        }
        .navigationTitle("Requests")
        
    }
}

struct ViewResponses_Previews: PreviewProvider {
    static var previews: some View {
        ViewResponses(pname: "", pid: "", people: [""])
    }
}
