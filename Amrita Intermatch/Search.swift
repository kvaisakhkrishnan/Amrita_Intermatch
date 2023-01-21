//
//  Search.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 18/11/22.
//

import SwiftUI

struct projectSearch : Identifiable{
    var id: UUID
    var pid : String
    var pname : String
    var faculty : String
    var keyword : [String]
    var desc : String
    
}


struct Search: View {
    @State var view = 0
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var locked = false
    @State var list_of_projects  : [projectSearch] = []
    @State  var load : Bool = false
    @State var alertShow = false
    @State var search : String = ""
    @State var tags : [String] = ["Select"]
    @State var selectedtags = ["Tags"]
    @State var type : [String] = ["Select","All","Faculty Name","Tags", "Project Type", "Project Name"]
    @State var ptype = ["Select", "Project", "Research", "Idea"]
    @State var stype : String = "Select"
    var body: some View {
        ZStack{
            
            NavigationView{
               
                
                List{
                    
                    Section(header: Text("FILTER"))
                    {
                        
                        Picker(selection: $stype, label: Text("Filter Type")) {
                            ForEach(type, id:\.self){
                                data in
                                Text(data).tag(data as String?)
                            }
                        }
                        .onChange(of: stype) { newValue in
                            check()
                        }
                    }
                  
                    if(view == 2)
                    {
                        Section(header: Text("KEYWORD")){
                            
                            TextField(text: $search, prompt: Text("Search Keywords")) {
                                Text("Search Keywords")
                            }
                        }
                    }
                    if(view == 3)
                    {
                        Picker(selection: $search, label: Text("Tags")) {
                            ForEach(tags, id:\.self){
                                data in
                                Text(data).tag(data as String?)
                            }
                        }
                        .onChange(of: search) { newValue in
                            addTag()
                        }
                        
                        VStack{
                            if(selectedtags.count == 1)
                            {
                                Text("No tags selected")
                                    .frame(maxWidth: .infinity, alignment:.center)
                                    .foregroundColor(Color(red:175/255, green:175/255, blue:175/255))
                            }
                            else
                            {
                                Text("Long Press to Remove Tags")
                                    .padding(.vertical)
                                    .frame(maxWidth: .infinity, alignment:.center)
                                    .foregroundColor(Color(red:175/255, green:175/255, blue:175/255))
                                LazyVGrid(columns: columns){
                                    ForEach(selectedtags, id:\.self)
                                    {
                                        data in
                                        
                                        Text(data)
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                                            .cornerRadius(30)
                                            .onLongPressGesture {
                                                
                                                removeTag(data: data)
                                                
                                            }
                                    }
                                }
                            }
                        }
                        .onAppear()
                        {
                            loadTags()
                        }
                    }
                    if(view == 4)
                    {
                        Picker(selection: $search, label: Text("Tags")) {
                            ForEach(ptype, id:\.self){
                                data in
                                Text(data).tag(data as String?)
                            }
                        }
                    }
                    
                    
                    
                    Button {
                        
                        loadProjects()
                        
                    } label: {
                        HStack{
                            Text("SEARCH")
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                            Image(systemName: "magnifyingglass")
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                        }
                        .frame(maxWidth: .infinity,alignment: .center)
                        
                    }
                    
                    Section(header: Text("SEARCH RESULT"))
                    {
                    if(list_of_projects.count==0)
                    {
                        Text("No Projects Found")
                            .foregroundColor(Color(red: 185/255, green: 185/255, blue: 185/255))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                   
                   else
                    {
                      
                      
                          
                           
                           ForEach(list_of_projects) { data in
                               
                               
                               NavigationLink {
                                   
                                   ShowProject(pid: data.pid, pname: data.pname, pfaculty: data.faculty, keywords: data.keyword, desc: data.desc)
                                   
                               } label: {
                                   
                                   
                                   
                                   
                                   VStack
                                   {
                                       Text(data.pname)
                                           .bold()
                                       
                                           .frame(maxWidth: .infinity,alignment: .leading)
                                       
                                           .padding(.bottom,3)
                                       
                                       Text(data.faculty)
                                           .frame(maxWidth: .infinity,alignment: .leading)
                                   }
                               }
                               
                               
                               
                               
                           }
                           if(list_of_projects.count>0){
                              
                               Text(String(list_of_projects.count)+" results found")
                                   .frame(maxWidth: .infinity, alignment: .center)
                                   .foregroundColor(Color(red:185/255, green:185/255, blue:185/255))
                               
                           }
                       }
                       
                    }
                    
                    
                    
                }
                .navigationTitle("Search")
                .alert("Empty Fields", isPresented: $alertShow) {
                    Button("OK", role: .cancel) { alertShow = false}
                }
               
                
                
                
          
            }
            
            
            
            
            
            
            
            
           if(load)
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
        .disabled(load)
        
        .onChange(of: view) { newValue in
            resetSearch()
        }
        
    }
    
    func resetSearch()
    {
        if view == 3 || view == 4
        {
            search = "Select"
        }
        else
        {
            search = ""
        }
    }
    
    func loadTags()
    {
        search = "Select"
        tags = ["Select"]
        load = true
        let headers = [
            "Content-Type": "application/json",
            "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
        ]
        
        // prepare json data
        let json: [String: Any] =
        ["collection": "Tags",
         "database": "Interconnect",
         "dataSource": "Cluster0"
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
                    tags.append(data["tag"] as! String)
                    i+=1
                }
                load = false


            }
          

        }


        task.resume()

        
        
        
    }
    
    
    func check()
    {
        list_of_projects = []
        if(stype == "All")
        {
            view = 1
        }
        else if(stype == "Faculty Name" || stype == "Project Name")
        {
            view = 2
        }
        
        else if(stype == "Tags")
        {
            view = 3
        }
        else if(stype == "Project Type")
        {
            view = 4
        }
        
    }
    
    
    func loadProjects()
    {
        if (stype == "Select" || (search == "" && stype != "All"))
        {
            alertShow = true
        }
        else
            {
            list_of_projects = []
            
            load = true
            
            let headers = [
                "Content-Type": "application/json",
                "Access-Control-Request-Headers": "*",
                "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
            ]
            
           if(stype == "All")
            {
               let json : [String : Any] =
                       ["collection": "Project",
                        "database": "Interconnect",
                        "dataSource": "Cluster0"
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
                      
                      let data = responseJSON["documents"]!
                       
                       var i = 0
                       while (i<data.count)
                       {
                           let temp = data[i] as! NSDictionary
                           let pid = temp["pid"] as! String
                           let pname = temp["name"] as! String
                          
                           let desc = temp["description"] as! String
                           let tags = temp["tags"] as! [String]
                          
                           let faculty = temp["email"] as! String

                           let tproject = projectSearch(id: UUID(), pid: pid, pname: pname, faculty: faculty, keyword: tags, desc: desc)

                           list_of_projects.append(tproject)
                           i += 1

                       }
                       load = false
                     
                      

                       
                       
                       
                   }
                  
                   
               }
               
               
               task.resume()
           }
            
            
            
            
            else if(stype == "Faculty Name")
            {
                var faculty_id : [String] = []
                
                let t_search = search.split(separator: " ")
                
                let json : [String : Any] =
                        ["collection": "Profile",
                         "database": "Interconnect",
                         "dataSource": "Cluster0",
                         "filter": [ "$or" : [ ["firstName": ["$in" : t_search]], ["lastName" : ["$in" : t_search]]]]
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
                       
                       let data = responseJSON["documents"]!
                        
                        var i = 0
                        while (i<data.count)
                        {
                            let temp = data[i] as! NSDictionary
                            faculty_id.append(temp["email"] as! String)
                            i += 1

                        }
                        
                        
                        
                        
                        
                        let json : [String : Any] =
                                ["collection": "Project",
                                 "database": "Interconnect",
                                 "dataSource": "Cluster0",
                                 "filter": ["email" : ["$in" : faculty_id]]
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
                               
                               let data = responseJSON["documents"]!
                                
                                var i = 0
                                while (i<data.count)
                                {
                                    let temp = data[i] as! NSDictionary
                                    let pid = temp["pid"] as! String
                                    let pname = temp["name"] as! String
                                   
                                    let desc = temp["description"] as! String
                                    let tags = temp["tags"] as! [String]
                                   
                                    let faculty = temp["email"] as! String

                                    let tproject = projectSearch(id: UUID(), pid: pid, pname: pname, faculty: faculty, keyword: tags, desc: desc)

                                    list_of_projects.append(tproject)
                                    i += 1

                                }
                                load = false
                              
                               

                                
                                
                                
                            }
                           
                            
                        }
                        
                        
                        task.resume()
                      
                       

                        
                        
                        
                    }
                   
                    
                }
                
                
                task.resume()
            }
            
            
            else if(stype == "Tags")
            {
                
                let json : [String : Any] =
                        ["collection": "Project",
                         "database": "Interconnect",
                         "dataSource": "Cluster0",
                         "filter" : ["tags" : ["$in" : selectedtags]]
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
                       
                       let data = responseJSON["documents"]!
                        
                        var i = 0
                        while (i<data.count)
                        {
                            let temp = data[i] as! NSDictionary
                            let pid = temp["pid"] as! String
                            let pname = temp["name"] as! String
                           
                            let desc = temp["description"] as! String
                            let tags = temp["tags"] as! [String]
                           
                            let faculty = temp["email"] as! String

                            let tproject = projectSearch(id: UUID(), pid: pid, pname: pname, faculty: faculty, keyword: tags, desc: desc)

                            list_of_projects.append(tproject)
                            i += 1

                        }
                        load = false
                      
                       

                        
                        
                        
                    }
                   
                    
                }
                
                
                task.resume()
            }
            
            
            else if(stype == "Project Type")
            {
                let json : [String : Any] =
                        ["collection": "Project",
                         "database": "Interconnect",
                         "dataSource": "Cluster0",
                         "filter" : ["category" : search]
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
                       
                       let data = responseJSON["documents"]!
                        
                        var i = 0
                        while (i<data.count)
                        {
                            let temp = data[i] as! NSDictionary
                            let pid = temp["pid"] as! String
                            let pname = temp["name"] as! String
                           
                            let desc = temp["description"] as! String
                            let tags = temp["tags"] as! [String]
                           
                            let faculty = temp["email"] as! String

                            let tproject = projectSearch(id: UUID(), pid: pid, pname: pname, faculty: faculty, keyword: tags, desc: desc)

                            list_of_projects.append(tproject)
                            i += 1

                        }
                        load = false
                      
                       

                        
                        
                        
                    }
                   
                    
                }
                
                
                task.resume()
            }
            
            else if(stype == "Project Name")
            {
                let json : [String : Any] =
                        ["collection": "Project",
                         "database": "Interconnect",
                         "dataSource": "Cluster0",
                         "filter" : ["name" : ["$regex" : search]]
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
                       
                       let data = responseJSON["documents"]!
                        
                        var i = 0
                        while (i<data.count)
                        {
                            let temp = data[i] as! NSDictionary
                            let pid = temp["pid"] as! String
                            let pname = temp["name"] as! String
                           
                            let desc = temp["description"] as! String
                            let tags = temp["tags"] as! [String]
                           
                            let faculty = temp["email"] as! String

                            let tproject = projectSearch(id: UUID(), pid: pid, pname: pname, faculty: faculty, keyword: tags, desc: desc)

                            list_of_projects.append(tproject)
                            i += 1

                        }
                        load = false
                      
                       

                        
                        
                        
                    }
                   
                    
                }
                
                
                task.resume()
            }
            
          
            
            
            
            
        }
    
    }
    func removeTag(data : String)
    {
        if let index = selectedtags.firstIndex(of: data) {
            selectedtags.remove(at: index)
        }
    }
    
    
    func addTag()
    {
        if(!selectedtags.contains(search)  && search != "Select"){
            selectedtags.append(search)
        }
    }
    
    
    
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
