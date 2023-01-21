//
//  ExpandProject.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 11/11/22.
//

import SwiftUI
import SwiftSMTP

struct ExpandMyProject: View {
    
    @Environment(\.dismiss) var dismiss
    
    
    @State var colabs : [String] = []
    @State var requests : [String] = []
    @State var pid : String
    @State var pname : String
    @State var keywords : [String]
    @State var desc : String
    @State var email : String
    
    @State var confirm = false
    @State var showAlert = false
    @State var loading = false
    @State var show = false
    
    let rows = [
            GridItem(.fixed(40)),
            GridItem(.fixed(40))
            
        ]
    var body: some View {
        
        
        ZStack{
        
           
                
                ScrollView{
                    VStack{
                        HStack{
                            
                            if pname == ""
                            {
                                Text("Idea Box")
                                    .font(.title)
                                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                    .padding(.top,10)
                            }
                            else
                            {
                                Text(pname)
                                    .font(.title)
                                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                    .padding(.top,10)
                            }
                            
                            
                            Button {
                                showAlert = true
                            } label: {
                                Text("Delete")
                                        .font(.title3)
                                        .padding(.trailing)
                                        .foregroundColor(.red)
                                }
                            }

                        
                        
                        
                        
                        Text("KEYWORDS")
                            .fontWeight(.bold)
                            .padding(.top,1)
                            .font(.callout)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                        
                        LazyHGrid(rows: rows) {
                            
                            
                            
                            
                            ForEach(keywords, id:\.self){value in
                                Text(value)
                                    .padding(10)
                                    .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                                    .foregroundColor(.white)
                                    .cornerRadius(30)
                            }
                            
                            
                        }
                        
                        
                        
                        VStack{
                            
                           
                            Text("DESCRIPTION")
                                .padding(.top,50)
                                .padding(.leading)
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text(desc)
                                .foregroundColor(.white)
                                .padding()
                                .padding(.bottom,20)
                            
                            
                            Text("COLLABORATIONS")
                                .padding(.top,30)
                                .padding(.leading)
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            if(colabs.count == 0)
                            {
                                Text("No Collaborations")
                                    .foregroundColor(.white)
                                    .padding()
                                    .padding(.bottom,20)
                            }
                            
                            
                            else
                            {
                                VStack{
                                    Text(String(colabs.count)+" collaboration(s) found")
                                        .foregroundColor(.white)
                                        .padding(.top)
                                    NavigationLink {
                                        viewColabs(pid: pid, people: colabs)
                                    } label: {
                                        Text("VIEW COLLABORATIONS")
                                            .fontWeight(.semibold)
                                            .padding(.vertical,10)
                                            .padding(.horizontal, 20)
                                        
                                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                            .background(.white)
                                            .cornerRadius(20)
                                            .padding(.bottom,20)
                                            .padding(.top,5)
                                        
                                        
                                        
                                    }
                                    
                                }
                            }
                            
                            
                            
                            
                            
                            Text("REQUESTS")
                                .padding(.top,30)
                                .padding(.leading)
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            
                            if(requests.count == 0)
                            {
                                Text("No Response")
                                    .foregroundColor(.white)
                                    .padding()
                                    .padding(.bottom,20)
                            }
                            
                            
                            else
                            {
                                VStack{
                                    Text(String(requests.count)+" response(s) found")
                                        .foregroundColor(.white)
                                        .padding(.top)
                                    NavigationLink {
                                        ViewResponses(pname: pname, pid: pid, people: requests)
                                    } label: {
                                        Text("VIEW REQUESTS")
                                            .fontWeight(.semibold)
                                            .padding(.vertical,10)
                                            .padding(.horizontal, 20)
                                        
                                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                            .background(.white)
                                            .cornerRadius(20)
                                            .padding(.bottom,20)
                                            .padding(.top,5)
                                        
                                        
                                        
                                    }
                                    
                                }
                            }
                            
                            
                           
                            
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                        .cornerRadius(30)
                        
                        
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
        .alert("Succesfully Deleted", isPresented: $confirm) {
            Button{
                confirm = false
            } label:
            {
                Text("OK")
            }
        }
        .alert("Confirm to delete", isPresented: $showAlert) {
            Button(role: .destructive) {
                showAlert = false
                deleteProject()
            } label: {
                Text("Confirm")
                  
            }

            Button("Cancel", role: .cancel) { showAlert = false}
        }
        .onAppear()
        {
            loadInterested()
        }
        
        
        
    }
    
       
    func deleteProject()
    {
        loading = true
        dismiss()
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
         "filter": [ "pid" : pid ]
        ]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/deleteOne")!
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
               
                
                
                
                let headers = [
                    "Content-Type": "application/json",
                    "Access-Control-Request-Headers": "*",
                    "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
                ]

                // prepare json data
                let json: [String: Any] =
                ["collection": "Likes",
                 "database": "Interconnect",
                 "dataSource": "Cluster0",
                 "filter": [ "pid" : pid ]
                ]
                
                
                let jsonData = try? JSONSerialization.data(withJSONObject: json)

                // create post request
                let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/deleteMany")!
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
                       
                        
                       
                        
                        
                        
                        // prepare json data
                        let json: [String: Any] =
                        ["collection": "Interested",
                         "database": "Interconnect",
                         "dataSource": "Cluster0",
                         "filter": [ "pid" : pid ]
                        ]
                        
                        
                        let jsonData = try? JSONSerialization.data(withJSONObject: json)

                        // create post request
                        let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/deleteMany")!
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
                                
                                
                                
                                
                                
                                
                                
                                
                                // prepare json data
                                let json: [String: Any] =
                                ["collection": "User",
                                 "database": "Interconnect",
                                 "dataSource": "Cluster0",
                                 "filter": [ "official": email],
                                 "update" : [
                                    "$inc":["memory": -1 ]
                                 ]
                                ]
                                
                                
                                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                                
                                // create post request
                                let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/updateOne")!
                                var request = URLRequest(url: url)
                                request.httpMethod = "POST"
                                request.allHTTPHeaderFields = headers
                                
                                request.httpBody = jsonData
                                
                                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                                    guard let data = data, error == nil else {
                                        print(error?.localizedDescription ?? "No data")
                                        return
                                    }
                                    _ = try? JSONSerialization.jsonObject(with: data, options: [])
                                    
                                    confirm = true
                                   
                                    
                                }
                                task.resume()
                                
                          
                               
                                
                                
                                
                                
                                
                                
                              
                                
                            }

                        }


                        task.resume()
                        
                        
                        
                        
                        
                        
                        
                        
                    }

                }


                task.resume()
                
                
                
                
                
                
                loading = false
            }

        }


        task.resume()
        
        
        

    }
    
    func loadInterested()
    {
        colabs = []
        requests = []
        loading = true
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
         "filter": [ "pid" : pid]
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
                var count = 0
                while count < reply.count
                {
                    let data = reply[count] as! NSDictionary
                    if(data["status"] as! Int == 1)
                    {
                        colabs.append(data["email"] as! String)
                    }
                   else
                    {
                        requests.append(data["email"] as! String)
                    }
                    count += 1
                }
                
                loading = false
            }

        }


        task.resume()
        
    }
    
   
    }

struct ExpandMyProject_Previews: PreviewProvider {
    static var previews: some View {
        ExpandMyProject(pid: "", pname: "", keywords: [""], desc: "", email: "")
    }
}
