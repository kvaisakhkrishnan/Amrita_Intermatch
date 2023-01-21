//
//  AddProject.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 14/11/22.
//

import SwiftUI






struct AddProject: View {
    @State var memory : Float = 0.0
    @State var email : String
    var type = ["Select","Project","Research"]
    @State var alertShow = false
    @State var emptyField = false
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var pname = ""
    @State var inserting = false
    @State var loading = false
    @State var ptype = "Select"
    @State var nstudents = ""
    @State var tags : [String] = ["Select"]
    @State var selectedtags : [String] = []
    @State var temp = "Select"
    @State var desc = ""
    @State var tagged = false
    @State var taggedShow = false
    @State var searchText = ""
    var body: some View {
       
            
            ZStack{
                
                if(memory == 25)
                {
                    VStack{
                        Text("Oops... Memory Exhausted!\n")
                            .fontWeight(.medium)
                            .font(.title2)
                        Text("You have exhausted your project limits\nClear Some projects from My Projects")
                            .foregroundColor(.gray)
                        Text("\n\nSteps to Clear Memory\n\n1. Go to Profile\n2. Select My Projects\n3. Select a project\n4. Click on Delete\n5. Click on Confirm and delete")
                            .foregroundColor(.gray)
                    }
                }
                else{
                    
                    
                    VStack
                    {
                        Form{
                            
                            
                            Section(header: Text("Work Title"))
                            {
                                TextField(text: $pname, prompt: Text("Work Title")) {
                                    Text("Title")
                                    
                                    
                                }
                            }
                            
                            
                            
                            
                            
                            Picker(selection: $ptype, label: Text("Work Type")) {
                                ForEach(type, id:\.self){
                                    data in
                                    Text(data).tag(data as String?)
                                }
                            }
                            
                            Section(header: Text("No of students"))
                            {
                                TextField(text: $nstudents, prompt: Text("No of students")) {
                                    Text("No of students")
                                    
                                }
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            Picker(selection: $temp, label: Text("Tags")) {
                                ForEach(tags, id:\.self){
                                    data in
                                    Text(data).tag(data as String?)
                                }
                            }
                            .onChange(of: temp) { newValue in
                                addTag()
                            }
                            
                            VStack{
                                if(selectedtags.count == 0)
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
                            
                            
                            Section(header: Text("Description"))
                            {
                                TextEditor(text: $desc)
                            }
                            
                            
                            
                            
                            Button {
                                
                                addProject()
                                
                            } label: {
                                HStack{
                                    Image(systemName: "plus")
                                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                        .bold()
                                    Text("ADD PROJECT")
                                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                        .bold()
                                }
                                .padding(10)
                                
                                .cornerRadius(20)
                                .frame(maxWidth: .infinity, alignment:.center)
                            }
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                    }
                    .navigationTitle("Add Project")
                }
                
                if(inserting || loading){
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
        
            .disabled(inserting)
            .alert("Project Added Succesfully", isPresented: $alertShow) {
                Button("OK", role: .cancel) { alertShow = false}
            }
            .alert("Missing Field", isPresented: $emptyField) {
                Button("OK", role: .cancel) { emptyField = false}
            }
            .onAppear()
        {
            checkMemory()
            loadTags()
        }
           
            
            
        
        
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return tags
        } else {
            return tags.filter { $0.contains(searchText) }
        }
    }
    
    func checkMemory()
    {
        
        loading = true
        
            
            let headers = [
                "Content-Type": "application/json",
                "Access-Control-Request-Headers": "*",
                "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
            ]

            // prepare json data
            let json: [String: Any] =
            ["collection": "User",
             "database": "Interconnect",
             "dataSource": "Cluster0",
             "filter": [ "official": email ]
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
                    let reply = responseJSON["document"]!
                    memory = reply["memory"] as! Float
                    
                    loading = false
                }
               
            }


            task.resume()

            
        
        
        
    }
    
    func loadTags()
    {
        tags = ["Select"]
        inserting = true
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
                tags.sort()
                inserting = false


            }
          

        }


        task.resume()

        
        
        
    }
    
    
    func addProject()
    {
        
        if(pname == "" || ptype == "Select" || nstudents == "" || selectedtags == ["Tags"] || desc == "")
        {
            emptyField = true
        }
        else{
            inserting = true
            
            let headers = [
                "Content-Type": "application/json",
                "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
            ]
            
            // prepare json data
            let json: [String: Any] =
            ["collection": "Project",
             "database": "Interconnect",
             "dataSource": "Cluster0",
             "document": [ "category": ptype, "name" : pname, "description" : desc, "email" : email, "nstudents" : nstudents, "tags" : selectedtags, "pid" : UUID().uuidString]
            ]
            
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            // create post request
            let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/insertOne")!
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
                
              
                // prepare json data
                let json: [String: Any] =
                ["collection": "User",
                 "database": "Interconnect",
                 "dataSource": "Cluster0",
                 "filter": [ "official": email],
                 "update" : [
                    "$inc":["memory": 1 ]
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
                    
                    
                    
                }
                task.resume()
                
          
                inserting = false
                alertShow = true
                
                
            }
            task.resume()
            
            
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
        if(!selectedtags.contains(temp)  && temp != "Select"){
            selectedtags.append(temp)
        }
    }
}

struct AddProject_Previews: PreviewProvider {
    static var previews: some View {
        AddProject(email: "")
    }
    
}
