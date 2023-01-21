//
//  Kitten.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 15/01/23.
//

import MongoKitten
import SwiftUI

struct Kitten: View {
    @State var data: [Document] = []
    
    var body: some View {
        VStack {
            List(data, id: \.self) { item in
                Text("HI")
              
            }
        }.onAppear {
            self.fetchData()
        }
    }
    
    func fetchData() {
        // Connect to MongoDB using MongoKitten
        let mongo = try MongoClient("mongodb://localhost:27017")
        let db = mongo["mydb"]
        let collection = db["people"]
        
        // Retrieve data from the "people" collection
        data = try! collection.find()
    }
}


struct Kitten_Previews: PreviewProvider {
    static var previews: some View {
        Kitten()
    }
}
