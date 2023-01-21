//
//  Profile.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 10/11/22.
//

import SwiftUI

struct Profile: View {
    @AppStorage("notification") var notification = true
    @State var memory : Float = 0.0
    @AppStorage("fname") var s_fname = ""
    @AppStorage("skip_user") var skip_user = ""
    @AppStorage("skip_password") var skip_password = ""
    @State var edit = false
    
    @State var aboutMe : String
    @State var name : String
    @State var role : String
    @State var email : String
    @State var github : String
    @State var Linkedin : String
    @State var Resume : String
    @State var tags : [String]
    @State var logout = false
   
    var body: some View {
     
            
            
            
        NavigationView {
            
            if(logout)
            {
                VStack{
                    Image("See you soon-pana")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Text("See You Soon!")
                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                        .font(.largeTitle)
                }
                .onAppear()
                {
                    logoutUser()
                }
            }
            
            else
            {
            
               

                
            VStack{
                
                
                
                Button {
                    edit = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                .font(.title2)
                .fontWeight(.bold)
                .padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)

                if(edit){
                    Text("Click on your name to edit it")
                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                }
                   
                
                TextField(text: $s_fname, prompt: Text("User Name")) {
                    Text("User Name")
                
                }
                
               
                    .font(.title)
                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .disabled(!edit)
                
                
               
                
               
                
                VStack{
                    Text(role)
                    
                    Text(email)
                    
                    
                    ProgressView(value: memory/25)
                    {
                        Text("Memory Usage : "+String(memory/0.25)+"%")
                    }
                    .progressViewStyle(LinearProgressViewStyle(tint:Color(red: 2/255, green: 100/255, blue: 48/255)))
                    .padding(.top,10)
                    .padding(.horizontal)
                    .padding(.bottom,10)
                    if(memory>15)
                    {
                        Text("Clear Memory")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .fontWeight(.medium)
                            .foregroundColor(.red)
                    }
                    
                    
                }
                .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                .fontWeight(.medium)
                .padding(.bottom,50)
                
                
                
                List{
                    
                    
                    
                        Toggle(isOn: $notification) {
                            Text("Login Notification")
                        
                    }
                    
                    
                    if role == "S"
                    {
                        NavigationLink {
                           UpdateProject(email: email)
                        } label: {
                            Text("My Ideas")
                        }
                    }
                    else
                    {
                        NavigationLink {
                            UpdateProject(email: email)
                        } label: {
                            Text("My Projects")
                        }
                    }
                    
                    NavigationLink{
                        History(email: email)
                    } label:
                    {
                       Text("History")
                    }
                    
                    
                    NavigationLink {
                        AboutMe(aboutMe:aboutMe, email: email)
                        
                    } label: {
                        Text("About Me")
                    }
                    
                    NavigationLink {
                        Interests(email: email)
                    } label: {
                        Text("Interests")
                    }
                    
                    NavigationLink {
                        Github(github: github, email: email)
                    } label: {
                        Text("GitHub")
                    }
                    NavigationLink {
                        LD(ld: Linkedin, email: email)
                    } label: {
                        Text("LinkedIn")
                    }
                    NavigationLink {
                        ResumeView(email: "" )
                    } label: {
                        Text("Resume")
                    }
                    
                    NavigationLink {
                        ReportBug()
                        
                    } label: {
                        Text("Report Bug")
                    }
                    
                    
                    
                    
                    
                   
                    
                    
                    
                    
                    
                    
                    
                }
                .task{
                    await getMemory()
                }
                
                
                if(edit)
                {
                    Button {
                        updateName()
                    } label: {
                        Text("MODIFY NAME")
                            .padding(.top)
                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                            .fontWeight(.semibold)
                    }

                    
                    
                }
                else{
                    Button {
                        logout = true
                    } label: {
                        Text("LOGOUT")
                            .padding(.top)
                        
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                    }
                }
                
                
                
                
               
                
                
            }
            
            
           
        }
                
                
            
        }
        
    }
    
    
   
    
    func updateName()
    {
        edit = false
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
               "$set":["firstName" : s_fname]
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
                  
              
               }
           }
       
               
           task.resume()
      }
    
    
    
    
    
    
    func getMemory() async
    {
        
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
            }
           
        }


        task.resume()

        
    }
    
    
        
       func logoutUser()
    {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            skip_user = ""
            skip_password = ""
        }
    }
       
    }


struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(aboutMe: "",name: "", role: "", email: "", github: "", Linkedin: "", Resume: "", tags: [""])
    }
}
