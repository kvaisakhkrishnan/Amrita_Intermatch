//
//  AddTags.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 16/12/22.
//

import SwiftUI

struct AddTags: View {
    @State var output : [String] = []
    @State var tagName : String = ""
    @State var loading = false
    @State var show = false
    var body: some View {
        
        ZStack
        {
            
            
            List{
                Section(header: Text("SEARCH TAG"))
                {
                    TextField(text: $tagName, prompt: Text("Department/Tags")) {
                        Text("Department/Tags")
                    }
                    
                    
                    
                }
                Section(header: Text("RESULTS"))
                {
                    if output.count == 0
                    {
                        Text("No Result")
                    }
                    else
                    {
                        ForEach(output, id:\.self)
                        {
                            data in
                            Text(data)
                        }
                    }
                }
                
                Section(header: Text("ADD TAG"))
                {
                    Button {
                        addTag()
                    } label: {
                        Text("ADD TAG")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                            .bold()
                    }
                }
            }
            
            
            if(loading)
             {
                VStack{
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.2)
                        .padding(15)
                        .background(Color(red: 225/255, green: 225/255, blue: 225/255))
                        .cornerRadius(12)
                    Spacer()
                }





            }

            
        }
        
        .disabled(loading)
        
        .navigationTitle("Add Tags")
        .alert("Tag Added Succesfully", isPresented: $show) {
            Button("OK", role: .cancel) { show = false}
        }
        .onChange(of: tagName) { newValue in
            getTag()
        }
    }
    
    func addTag()
    {
        loading = true
       
        let headers = [
            "Content-Type": "application/json",
            "Access-Control-Request-Headers": "*",
            "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
        ]

        // prepare json data
        let json: [String: Any] =
        ["collection": "Tags",
         "database": "Interconnect",
         "dataSource": "Cluster0",
         "document" : ["tag" : tagName.uppercased()]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/insertOne")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let _ = responseJSON as? [String: Any] {
                
                loading = false
                show = true
            }
           

        }


        task.resume()
    }
    
    func getTag()
    {
        output = []
        let headers = [
            "Content-Type": "application/json",
            "Access-Control-Request-Headers": "*",
            "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
        ]

        // prepare json data
        let json: [String: Any] =
        ["collection": "Tags",
         "database": "Interconnect",
         "dataSource": "Cluster0",
         "filter": [ "tag" : ["$regex" : tagName.uppercased()]]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/find")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: NSArray] {
                let reply = responseJSON["documents"]!
                output = []
                var i = 0
                while i < reply.count
                {
                    let data = reply[i] as! NSDictionary
                    output.append(data["tag"] as! String)
                    i+=1
                }

            }
           

        }


        task.resume()

    }
}

struct AddTags_Previews: PreviewProvider {
    static var previews: some View {
        AddTags()
    }
}
