//
//  UpdateProject.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 15/12/22.
//

import SwiftUI


struct my_project : Identifiable{
    var id: UUID
    var pid : String
    var pname : String
    var keyword : [String]
    var desc : String
    var category : String
    
}



struct UpdateProject: View {
    
    @State var project_list : [my_project] = []
    @State var loading = false
    @State var email : String
    
    var body: some View {
        
        
        
            ZStack
            {
                
                
                
                
                List{
                    
                    ForEach(project_list) { my_project in
                       
                            
                    

                            
                        NavigationLink {
                            ExpandMyProject(pid: my_project.pid, pname: my_project.pname, keywords: my_project.keyword, desc: my_project.desc, email: email)
                        } label: {
                            
                            if my_project.category == "Idea"
                            {
                                VStack
                                {
                                    Text("Idea Box")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .fontWeight(.semibold)
                                    Text(my_project.desc)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .fontWeight(.light)
                                        .font(.body)
                                        
                                }
                            }
                            else
                            {
                                Text(my_project.pname)
                            }
                            
                                
                            }
                                
                           
                        
                        
                        
                       

                    }
                }
                
                if(project_list.count == 0)
                {
                    Text("No Projects")
                        .foregroundColor(Color(red: 185/255, green: 185/255, blue: 185/255))
                        .font(.title3)
                        .fontWeight(.regular)
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
            .navigationTitle("My Project")
        
        .onAppear()
    {
        loadProject()
    }
        
       
    }
    
        
    
    
    
    func loadProject()
    {
        project_list = []
        loading = true
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
         "filter": [ "email": email]
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
                while i < reply.count{
                    let data = reply[i] as! NSDictionary
                    let temp = my_project(id: UUID(), pid: data["pid"] as! String, pname: data["name"] as! String, keyword: data["tags"] as! [String],  desc: data["description"] as! String, category: data["category"] as! String)
                    project_list.append(temp)
                    i+=1
                }

            }
          
            loading = false
        }


        task.resume()
    }
    
}

struct UpdateProject_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProject(email: "")
    }
}
