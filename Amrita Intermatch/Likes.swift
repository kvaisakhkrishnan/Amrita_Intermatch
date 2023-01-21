//
//  Likes.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 10/11/22.
//

import SwiftUI

struct project : Identifiable{
    var id: UUID
    var pid : String
    var pname : String
    var match : Double
    var faculty : String
    var keyword : [String]
    var published : String
    var desc : String
    
}



struct Likes: View {
    
    @State var email : String
    @State var plist : [project] = []
    @State var isloading = false
    var body: some View {
        
        
        
       
        
            
            
            ZStack{
                NavigationView {
                    
                   
                    
                    if(plist.count == 0)
                    {
                        
                        Text("No liked projects")
                            .foregroundColor(Color(red: 185/255, green: 185/255, blue: 185/255))
                            .font(.title3)
                            .fontWeight(.regular)
                    }
                    
                    
                    else{
                    
                    List{
                        
                        
                        
                        ForEach(plist) { data in
                            
                            NavigationLink {
                                ExpandProject(pid: data.pid, pname: data.pname, pfaculty: data.faculty, keywords: data.keyword, desc: data.desc, published: data.published, match: data.match, email: email, user_email: email)
                            } label: {
                                VStack
                                {
                                    Text(data.pname)
                                        .bold()
                                        .padding(.bottom,2)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                    ProgressView(value: data.match/100)
                                    {
                                        Text("Match : "+String(data.match)+"%")
                                    }
                                    .progressViewStyle(LinearProgressViewStyle(tint:Color(red: 2/255, green: 100/255, blue: 48/255)))
                                    .padding(.bottom,10)
                                    
                                    
                                }
                            }
                            
                            
                            
                            
                        }
                            
                        }
                   
                        
                        
                        
                        
                    }
                    
                        
                    
                }
                
               
               
               
                
                if(isloading)
                {
                    ProgressView()
                        .scaleEffect(1.2)
                        .padding(15)
                        .background(Color(red: 225/255, green: 225/255, blue: 225/255))
                        .cornerRadius(12)
                }
                
            }
        
            .disabled(isloading)
        
            .onAppear{
                likedProjects()
            }
        
        
        
        
    }
    
   
    
    
    func likedProjects()
    {
        plist = []
        isloading = true
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
         "filter" : ["email":email, "liked" : true, "moved" : false]
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
               
                let document = responseJSON["documents"]!
                plist = []
                for elem in document
                {
                    
                    let temp = elem as! NSDictionary
                    let pid = temp["pid"] as! String
                    let match = temp["match"] as! Double
                    
                    
                    
                    
                    let json: [String: Any] =
                    ["collection": "Project",
                     "database": "Interconnect",
                     "dataSource": "Cluster0",
                     "filter" : ["pid":pid]
                    ]
                    
                    let jsonData = try? JSONSerialization.data(withJSONObject: json)
                    
                    // create post request
                    let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/findOne")!
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
                        if let responseJSON = responseJSON as? [String: NSDictionary] {
                            
                            let document = responseJSON["document"]!
                            let tags : [String] = document["tags"] as! [String]
                            let pname = document["name"] as! String
                            let desc = document["description"] as! String
                            let faculty = document["email"] as! String
                            let x = project(id:UUID(),pid: pid , pname: pname, match: match,faculty: faculty,keyword: tags, published: "",desc: desc)
                            plist.append(x)
                           
                            
                            
                            
                        }
                      
                        
                    }
                    
                        
                        
                        task.resume()
                    
                    
                   
                }
                
               
                
            }
           
            isloading = false
            
        }
        
        
        task.resume()
        
    }
}

struct Likes_Previews: PreviewProvider {
    static var previews: some View {
        Likes(email: "")
    }
}
