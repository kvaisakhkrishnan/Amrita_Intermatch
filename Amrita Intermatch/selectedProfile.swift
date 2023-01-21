//
//  seeProfile.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 16/12/22.
//

import SwiftUI
import SwiftSMTP



struct selectedProfile: View {
    @State var show = false
    @State var email : String
    @State var loading = false
    @State var loading2 = false
    @State var p_name = ""
    @State var pid : String
    @State var p_github = ""
    @State var p_linkedin = ""
    @State var p_resume = ""
    @State var p_interests : [String] = []
    @State var p_about = ""
    var body: some View {
        
        ZStack
        {
            
            
            VStack{
                Text(p_name)
                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                    .font(.title2)
                    .padding(.vertical)
                
                List{
                   
                    
                    Section(header: Text("About Me"))
                    {
                        Text(p_about)
                    }
                    
                    Section(header: Text("Amrita Email"))
                    {
                        Text(email)
                    }
                    
                    Section(header: Text("Areas of Interest"))
                    {
                       if(p_interests == [])
                        {
                           Text("No Areas of Interest")
                       }
                        else
                        {
                            ForEach(p_interests, id:\.self)
                            {
                                data in
                                Text(data)
                            }
                        }
                    }
                    
                    Section(header: Text("Github Link"))
                    {
                        if(p_github == "")
                        {
                            Text("No valid link given")
                        }
                        else
                        {
                            NavigationLink {
                                ViewPDF(link: p_github)
                            } label: {
                                Text("View Github Profile")
                            }
                        }

                    }
                    
                    
                    Section(header: Text("Linkedin Link"))
                    {
                        if(p_linkedin == "")
                        {
                            Text("No valid link given")
                        }
                        else
                        {
                            NavigationLink {
                                ViewPDF(link: p_linkedin)
                            } label: {
                                Text("View Linkedin Profile")
                            }
                        }

                    }
                    
                    
                    Section(header: Text("Resume Link"))
                    {
                        if(p_resume == "")
                        {
                            Text("No valid link given")
                        }
                        else
                        {
                            NavigationLink {
                                ViewPDF(link: p_resume)
                            } label: {
                                Text("View Resume Profile")
                            }
                        }

                    }
                    
                    
                    
                    
                }
            }
            
            
            
            
            
            
            
            if(loading || loading2)
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
        .disabled(loading || loading2)
        .alert("Candidate Notified", isPresented: $show) {
            Button {
                
            } label: {
                Text("OK")
            }

        }
        .onAppear()
        {
            loadProfile()
        }
        
        
    }
    
    
    
    func informStudent()
    {
        
        
      
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
         "filter": [ "email": email, "pid" : pid],
         "update" : [
            "$set":["status" : true]
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
            if let _ = responseJSON as? [String: Any] {
               
                loading = false
                
            }
           
        }


        task.resume()
        loading2 = true
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
            let sender = Mail.User(name: "Amrita Intermatch", email: "kvaisakhkrishnan@gmail.com")
            let reciever = Mail.User(name: p_name, email: email)
           
            let mail = Mail(
                from: sender,
                to: [reciever],
                subject: "Hurray, You are shortlisted!",
                text: "Congrats "+p_name+",\n\nThis is an automated reply to your request and we are happy to inform you that you are shortlisted by the faculty.\n\nRegards\nAmrita Intermatch"
            )

            smtp.send(mail) { (error) in
                if let error = error {
                    print(error)
                }
                
                
                loading2 = false
                show = true
                
            }
        }
        
        
        
       
    }
    
    
    func loadProfile()
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
         "filter": [ "email": email]
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
                
                let fn =  reply["firstName"] as! String
                let ln = reply["lastName"] as! String
                p_name = fn + " " + ln
                p_resume = reply["resume"] as! String
                p_github = reply["github"] as! String
                p_linkedin = reply["linkedin"] as! String
                p_interests = reply["interests"] as! [String]
                p_about = reply["aboutMe"] as! String

                loading = false

            }
           
        }


        task.resume()
    }
}

struct selectedProfile_Previews: PreviewProvider {
    static var previews: some View {
        selectedProfile(email: "", pid: "")
    }
}
