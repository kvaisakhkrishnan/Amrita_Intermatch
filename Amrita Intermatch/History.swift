//
//  History.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 17/12/22.
//

import SwiftUI


struct list_project : Identifiable{
    var id: UUID
    var pid : String
    var pname : String
    var faculty : String
    var keyword : [String]
    var category : String
    var desc : String
    var status : Bool
    
}

struct History: View {
    @State var status : [Bool] = []
    @State var loading = false
    @State var email : String
    @State var list : [list_project] = []
    var body: some View {
        NavigationView{
            ZStack
            {
                
                if(list.count == 0)
                {
                    Text("No History")
                        .foregroundColor(Color(red: 185/255, green: 185/255, blue: 185/255))
                        .font(.title3)
                        .fontWeight(.regular)
                }
                else
                {
                    List{
                        ForEach(list)
                        { data in
                            
                            Section(header: Text(data.category))
                            {
                                VStack{
                                    Text(data.pname)
                                        .padding(.bottom, 5)
                                        .bold()
                                    Text(data.desc)
                                        .padding(.bottom, 5)
                                    Text("-- "+data.faculty)
                                    HStack
                                    {
                                        Text("Status: ")
                                            .bold()
                                        if(data.status == true)
                                        {
                                            Text("Accepted")
                                                .foregroundColor(.green)
                                                .bold()
                                        }
                                        else
                                        {
                                            Text("Waiting")
                                                .foregroundColor(.red)
                                                .bold()
                                        }
                                        Spacer()
                                    }
                                    .padding(.top,5)
                                    .padding(.bottom, 5)
                                    
                                    if(data.status == true)
                                    {
                                        
                                        
                                        
                                        NavigationLink(destination: Community()) {
                                            
                                            Text("Visit Community")
                                            
                                                .foregroundColor(Color(red: 150/255, green: 150/255, blue: 150/255))
                                            
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            
                                        }
                                        .padding(.bottom, 5)
                                        
                                    }
                                    
                                }
                            }
                            
                            
                            
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
            .onAppear()
            {
                getHistory()
            }
            
        }
    }
        
        func getHistory()
        {
            loading = true
            list = []
            var t_list : [String] = []
            
            let headers = [
                "Content-Type": "application/json",
                "Access-Control-Request-Headers": "*",
                "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
            ]
            
            // prepare json data
            let json: [String: Any] =
            ["collection": "Interested",
             "database": "Interconnect",
             "dataSource": "Cluster0",
             "filter": [ "email": email ]
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
                    
                    var i = 0
                    while i < reply.count
                    {
                        let data = reply[i] as! NSDictionary
                        t_list.append(data["pid"] as! String)
                        status.append(data["status"] as! Bool)
                        i += 1
                    }
                    
                    let headers = [
                        "Content-Type": "application/json",
                        "Access-Control-Request-Headers": "*",
                        "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
                    ]
                    
                    // prepare json data
                    let json: [String: Any] =
                    ["collection": "Project",
                     "database": "Interconnect",
                     "dataSource": "Cluster0",
                     "filter": [ "pid": ["$in" : t_list]]
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
                            
                            var i = 0
                            while i < reply.count
                            {
                                let data = reply[i] as! NSDictionary
                                let t_proj = list_project(id: UUID(), pid: data["pid"] as! String, pname: data["name"] as! String, faculty: data["email"] as! String, keyword: data["tags"] as! [String], category: data["category"] as! String, desc: data["description"] as! String, status: status[i])
                                list.append(t_proj)
                                i += 1
                            }
                            loading = false
                            
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    task.resume()
                    
                    
                }
                
                
                
            }
            
            
            task.resume()
            
        }
    
    
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History(email: "cb.en.u4cse20069@cb.students.amrita.edu")
    }
}
