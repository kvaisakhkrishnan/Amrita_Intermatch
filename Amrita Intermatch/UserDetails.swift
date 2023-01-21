//
//  UserDetails.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 24/11/22.
//

import SwiftUI

struct UserDetails: View {
    @State var newPage = false
    @State var github = ""
    @State var about = ""
    @State var linkedin = ""
    @State var resume = ""
    @State var interest : [String] = []
    @State var loading = false
    @State var email : String
    @State var temp = "Select"
    @State var loading2 = false
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var tags : [String] = []

    var body: some View {
        if(newPage == true)
        {
            Load(email: email)
        }
        
        else
        {
            ZStack{
                
            VStack{
                Image("more")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                
                List{
                    TextField(text: $about, prompt: Text("About Me")) {
                        Text("About")
                    }
                    TextField(text: $linkedin, prompt: Text("Linkedin")) {
                        Text("Linkedin")
                    }
                    TextField(text: $github, prompt: Text("GitHub Link")) {
                        Text("Git")
                    }
                    TextField(text: $resume, prompt: Text("Resume Link")) {
                        Text("Resume")
                    }
                    
                    
                    
                    
                    
                    Section(header : Text(""))
                    {
                        Picker(selection: $temp, label: Text("Add Interests")
                            .foregroundColor(.secondary)) {
                                ForEach(tags, id:\.self){
                                    data in
                                    Text(data).tag(data as String?)
                                }
                            }
                    }
                    
                    
                    Section(header : Text("Interests"))
                    {
                    if(interest.count == 0)
                    {
                        Text("You have no areas of interest")
                            .frame(maxWidth: .infinity,alignment: .center )
                            .foregroundColor(Color(red:185/255, green: 185/255, blue: 185/255))
                    }
                    else
                    {
                        
                        
                        Text("Long Press to Remove Tags")
                            .padding(.vertical)
                            .frame(maxWidth: .infinity, alignment:.center)
                            .foregroundColor(Color(red:175/255, green:175/255, blue:175/255))
                        LazyVGrid(columns: columns){
                            ForEach(interest, id:\.self)
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
                    
                    
                    
                    
                    Button {
                        
                        updateData()
                        
                    } label: {
                        if(github == "" && about == "" && linkedin == "" && resume == "" && interest == [""])
                        {
                            Text("SKIP")
                                .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                .font(.headline)
                                .padding(.bottom)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top)
                        }
                        else
                        {
                            Text("ADD DATA")
                                .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                .font(.headline)
                                .padding(.bottom)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top)
                        }
                        
                    }
                    
                    
                    
                }
                .onChange(of: temp) { newValue in
                    addTag()
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
                loadTags()
            }
            
            
           
        }
        
    }
                  
        
    
    
    func loadTags()
    {
        tags = ["Select"]
        loading = true
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
                loading = false


            }
          

        }


        task.resume()

        
        
        
    }
    
    func updateData()
    {
        
       loading = true
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
         "filter":  ["email": email],
         "update" : [
            "$set":["interests":interest, "aboutMe" : about, "linkedin" : linkedin, "github" : github, "resume" : resume]
         ]
                   
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/updateOne")!
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
            if responseJSON is [String: Any] {
               
                loading = false
              newPage = true
                
            }
        }
    
            
        task.resume()
    }
    
    
    func addTag()
    {
        if(!interest.contains(temp)  && temp != "Select"){
           interest.append(temp)
        }
    }
    
    
    func removeTag(data : String)
    {
        if let index = interest.firstIndex(of: data) {
            interest.remove(at: index)
        }
    }

    
    
}

struct UserDetails_Previews: PreviewProvider {
    static var previews: some View {
        UserDetails(email: "")
    }
}
