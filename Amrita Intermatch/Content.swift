//
//  Content.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 29/12/22.
//

import SwiftUI



struct Content: View {
    let names = ["Holly", "Josh", "Rhonda", "Ted"]
    @State private var searchText = ""

    var body: some View {
        List {
        NavigationStack {
           
                ForEach(searchResults, id: \.self) { name in
                   
                        Text(name)
                   
                }
            }
           
        }
        .searchable(text: $searchText) {
            ForEach(searchResults, id: \.self) { result in
                Text("Are you looking for \(result)?").searchCompletion(result)
            }
        }
    }

    var searchResults: [String] {
        if searchText.isEmpty {
            return names
        } else {
            return names.filter { $0.contains(searchText) }
        }
    }
}

struct Content_Previews: PreviewProvider {
    static var previews: some View {
        Content()
    }
}
