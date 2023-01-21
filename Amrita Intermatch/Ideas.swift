//
//  AddProject.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 18/11/22.
//

import SwiftUI
import SwiftSMTP


struct faculty
{
    var pos : Int
    var id : UUID
    var fname : String
    var lname : String
    var interests : [String]
    var about : String
    var likedin : String
    var github : String
    var match : Double
    var email : String
}


struct Ideas: View {
    @State var loading = false
    @State var memory : Float = 0.0
    @AppStorage("skip_user") var skip_user = ""
    @State var visibility : Bool = false
    @State var successAlert = false
    @State var recommend : [faculty] = []
    @State var flist : [faculty] = []

    @State var email : String
    var type = ["Select","Project","Research"]
    @State var alertShow = false
    @State var emptyField = false
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var pname = ""
    @State var inserting = false
    @State var ptype = "Select"
    @State var nstudents = ""
    @State var tags = ["Select"]
    @State var selectedtags : [String] = []
    @State var temp = "Select"
    @State var desc = ""
    @State var tagged = false
    @State var taggedShow = false
    
    var body: some View {
        NavigationView{
            
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
                            
                            
                            Section(header: Text("Idea Description")){
                                
                                TextEditor(text: $desc)
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
                                    Text("No tags selected. Tags help us to recommend you the right faculty and team.")
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
                            
                            Section(header: Text("Visibility"))
                            {
                                VStack
                                {
                                    Toggle("Public View", isOn: $visibility)
                                    if(visibility == true)
                                    {
                                        Text("Your Idea will be visible to everyone")
                                            .frame(maxWidth: .infinity, alignment:.center)
                                            .foregroundColor(Color(red:175/255, green:175/255, blue:175/255))
                                    }
                                    else
                                    {
                                        Text("Your Idea will be private")
                                            .frame(maxWidth: .infinity, alignment:.center)
                                            .foregroundColor(Color(red:175/255, green:175/255, blue:175/255))
                                    }
                                }
                            }
                            
                            
                            Section(header: Text(""))
                            {
                                Button {
                                    
                                    addProject()
                                    
                                } label: {
                                    HStack{
                                        Image(systemName: "plus")
                                            .bold()
                                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                        Text("ADD IDEA")
                                            .bold()
                                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                    }
                                    .padding(10)
                                    .cornerRadius(20)
                                    .frame(maxWidth: .infinity, alignment:.center)
                                }
                            }
                            
                            
                            
                            if(recommend.count != 0)
                            {
                                
                                Section(header : Text("Faculty List")){
                                    ForEach(recommend, id:\.id){
                                        data in
                                        VStack{
                                            HStack{
                                                Text(String(data.pos))
                                                    .font(.largeTitle)
                                                    .foregroundColor(Color(red: 125/255, green: 125/255, blue: 125/255))
                                                
                                                VStack
                                                {
                                                    Text(data.fname + " " + data.lname)
                                                        .padding(.bottom,1)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                                        .font(.title3)
                                                        .fontWeight(.semibold)
                                                    Text(data.about)
                                                        .foregroundColor(Color(red: 125/255, green: 125/255, blue: 125/255))
                                                    
                                                    Text("Similarty in domain interests: "+String(data.match)+"%")
                                                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                                        .frame(maxWidth: .infinity,alignment: .leading)
                                                        .padding(.top,1)
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                }
                                                .padding(.leading)
                                                
                                            }
                                            Button {
                                                
                                                requestFaculty(details: data)
                                                
                                            } label: {
                                                Text("Resquest Faculty")
                                                    .padding(10)
                                                    .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                                                    .cornerRadius(10)
                                                    .foregroundColor(.white)
                                            }
                                            .padding(.bottom)
                                            
                                        }
                                        
                                    }
                                }
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    .navigationTitle("Idea")
                    
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
            .onAppear()
            {
                
                loadTags()
            }
            .alert("Project Added Succesfully", isPresented: $alertShow) {
                Button("OK", role: .cancel) { alertShow = false}
            }
            .alert("Missing Field", isPresented: $emptyField) {
                Button("OK", role: .cancel) { emptyField = false}
            }
            
            .alert("Faculty Notified Succesfully", isPresented: $successAlert) {
                Button("OK", role: .cancel)
                { successAlert = false
                   
                    
                }
            }
           
            
            
        }
        
        .onAppear()
        {
            checkMemory()
            resetData()
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
    
    
    func resetData()
    {
        tags = ["Select"]
        recommend = []
        flist = []
        pname = ""
        ptype = "Select"
        nstudents = ""
        temp = "Select"
        desc = ""
        visibility = false
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
    
    
    
    func requestFaculty(details : faculty)
    {
   
        
        
       inserting = true
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
            let sender = Mail.User(name: "Amrita Intermatch", email: "kvaisakhkrishnan@gmail.com")
            let reciever = Mail.User(name: details.fname, email: details.email)
            let mail = Mail(
                from: sender,
                to: [reciever],
                subject: "Idea Box Filled",
                text: "Hi "+details.fname+",\n\nOur student, "+skip_user+" has contributed towards our Idea Box, and we are so excited!\n\nIdea Description : "+desc+"\n\nHe/she wants to collaborate with you as we found that the projects matches with "+String(details.match)+" % of your areas of interest.\n\nRegards\nAmrita Intermatch"
            )

            smtp.send(mail) { (error) in
                if let error = error {
                    print(error)
                }
                
                
              
                
            }
            inserting = false
            successAlert = true
        }
        
    }
    
    
    func matchCalculate()
    {
       
        inserting = true
        var i = 0
        while i < flist.count{
            var match = 0.0
            for j in selectedtags{
                if flist[i].interests.contains(j)
                {
                    match += 1
                }
            }
            match = match / (Double(selectedtags.count))
            flist[i].match = match * 100
           i += 1
        }
        
        
        
        var location = 1
        
        while(flist.count > 0)
        {
            var large = flist[0].match
            var pos = 1
            var loc = 0
            while(pos < flist.count)
            {
                if(large < flist[pos].match)
                {
                    large = flist[pos].match
                    loc = pos
                    
                }
                pos += 1
            }
        
            if(flist[loc].match != 0){
                flist[loc].pos = location
                recommend.append(flist[loc])
                location += 1
            }
                flist.remove(at: loc)
            
        }
        
       
        inserting = false
        
       
    }
    
    func addProject()
    {
        
        if(selectedtags.count == 0 || desc == "")
        {
            emptyField = true
        }
        else if(visibility == true){
            flist = []
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
             "document": [ "category": "Idea", "name" : "Idea Box", "description" : desc, "email" : email, "nstudents" : "0",  "tags" : selectedtags, "pid" : UUID().uuidString]
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
                
                
                
                
                if(selectedtags.count == 0)
                {
                    
                    inserting = false
                }
                else
                {
                   
                    let headers = [
                        "Content-Type": "application/json",
                        "Access-Control-Request-Headers": "*",
                        "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
                    ]
                    
                    // prepare json data
                    let json: [String: Any] =
                    ["collection": "Profile",
                     "database": "Interconnect",
                     "dataSource": "Cluster0",
                     "filter": [ "role" : "F"]
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
                            while(i<reply.count)
                            {
                                let temp = reply[i] as! NSDictionary
                                let fname = temp["firstName"] as! String
                                let lname = temp["lastName"] as! String
                                let interests = temp["interests"] as! [String]
                                let about = temp["aboutMe"] as! String
                                let github = temp["github"] as! String
                                let linkedin = temp["linkedin"] as! String
                                let email = temp["email"] as! String
                                let tfac = Amrita_Intermatch.faculty(pos:0,id : UUID(), fname: fname, lname: lname, interests: interests, about: about, likedin: linkedin, github: github, match: 0.0, email: email)
                                flist.append(tfac)
                                
                                i += 1
                            }
                            
                            matchCalculate()
                            
                            
                        }
                      
                        
                    }
                    
                    
                    task.resume()
                    
                    
                }
                
                
            }
            task.resume()
            
            
        }
        else
        {
            inserting = true
            let headers = [
                "Content-Type": "application/json",
                "Access-Control-Request-Headers": "*",
                "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
            ]
            
            // prepare json data
            let json: [String: Any] =
            ["collection": "Profile",
             "database": "Interconnect",
             "dataSource": "Cluster0",
             "filter": [ "role" : "F"]
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
                    while(i<reply.count)
                    {
                        let temp = reply[i] as! NSDictionary
                        let fname = temp["firstName"] as! String
                        let lname = temp["lastName"] as! String
                        let interests = temp["interests"] as! [String]
                        let about = temp["aboutMe"] as! String
                        let github = temp["github"] as! String
                        let linkedin = temp["linkedin"] as! String
                        let email = temp["email"] as! String
                        let tfac = Amrita_Intermatch.faculty(pos:0,id : UUID(), fname: fname, lname: lname, interests: interests, about: about, likedin: linkedin, github: github, match: 0.0, email: email)
                        flist.append(tfac)
                        
                        i += 1
                    }
                    
                    matchCalculate()
                    
                    
                }
              
                
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

struct Ideas_Previews: PreviewProvider {
    static var previews: some View {
        Ideas(email: "")
    }
    
}
