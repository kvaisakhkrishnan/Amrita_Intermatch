//
//  Tab.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 10/11/22.
//

import SwiftUI
import SwiftSMTP

struct Load: View {
    
    @AppStorage("notification") var notification = true
    
    let myTime = Date()
    
    @AppStorage("aboutMe") var s_aboutMe = ""
    @AppStorage("git") var s_github = ""
    @AppStorage("likedin") var s_ld = ""
    @AppStorage("fname") var s_fname = ""
    @AppStorage("resume") var s_resume = ""
    
    @State var loading = false
    @State var email : String
    @State var loadProfile = false
    @State var interests : [String] = []
    @State var typ : String = "F"
    @State var github : String = ""
    @State var about : String = ""
    @State private var size = 1.5
    @State private var opacity = 0.0
    @State private var opacity2 = 0.0
    @State var dpname = ""
    @State var linkedin = ""
    @State var resume = ""
    
    @State var pname = ""
    
    
    var body: some View {
        if(loadProfile)
        {
            
            Tab(email: email, tags: interests, typ: typ, github: github, aboutMe: about, name: pname, role: typ, linkedin: linkedin, resume: resume)
                
        }
        else
        {
            
           
                
           
            ZStack{
                
                VStack{
                    Spacer()
                    Text("Welcome!")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                    Text("Amrita \nINTERMATCH")
                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                        .font(.system(size: 50))
                       
                      
                    
                        
                    
                    
                    ProgressView()
                        .scaleEffect(1.2)
                    Spacer()
                }
               
                   
                
                
                
                .onAppear { LoadData() }
                
                
                
                
                
                
                ZStack{
                    Rectangle()
                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                        .ignoresSafeArea()
                        
                        
                        .opacity(opacity)
                    VStack{
                        Text("WELCOME")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                            .opacity(opacity2)
                            
                        
                        Text(pname)
                            
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                            .opacity(opacity2)
                            .font(.largeTitle)
                    }
                }
               
                
                
                
            }
            
                
                
        
        }
            
        
        
    }
    
    
    
    func sendEmail()
    {
       
        
        loading = true
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
            let sender = Mail.User(name: "Amrita Intermatch", email: "kvaisakhkrishnan@gmail.com")
            let reciever = Mail.User(name: pname, email: email)
           
           
            let mail = Mail(
                from: sender,
                to: [reciever],
                subject: "You're logged in!",
                text: "Hi "+pname+",\n\nThis is an automated mail as we have detected a login in to your account.\n\nRegards\nAmrita Intermatch"
            )
            
            
            

            smtp.send(mail) { (error) in
                if let error = error {
                    print(error)
                }
                
                
                loading = false
               
                
            }
        }
        
    }
    
    
    func LoadData()
    {
        
        
        
        
       
        
        
        
        
       
        loading = true
        
        
        let format = DateFormatter()
        format.timeStyle = .short
        format.dateStyle = .short
        let time = format.string(from: myTime)
        
        let headers = [
            "Content-Type": "application/json",
            "Access-Control-Request-Headers": "*",
            "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
        ]
        
        // prepare json data
        let json2: [String: Any] =
        ["collection": "Logs",
         "database": "Interconnect",
         "dataSource": "Cluster0",
         "document": [ "email": email, "time" : time]
        ]
      
        
        let jsonData2 = try? JSONSerialization.data(withJSONObject: json2)
        
        // create post request
        let url2 = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/insertOne")!
        var request2 = URLRequest(url: url2)
        request2.httpMethod = "POST"
        request2.allHTTPHeaderFields = headers
       
        // insert json data to the request
        request2.httpBody = jsonData2
        
        let task2 = URLSession.shared.dataTask(with: request2) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let _ = responseJSON as? [String: NSDictionary] {
              
                
            }
         
            
        }
        
        
        task2.resume()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
  
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
                let fname = reply["firstName"] as! String
                pname = fname
                interests = reply["interests"] as! [String]
                typ = reply["role"] as! String
                about = reply["aboutMe"] as! String
                github = reply["github"] as! String
                linkedin = reply["linkedin"] as! String
                
                
                s_aboutMe = about
                s_github = github
                s_ld = linkedin
                s_fname = fname
                
                
                if typ == "S"
                {
                    typ = "Student"
                }
                else
                {
                    typ = "Faculty"
                }
                
                if(notification == true)
                {
                    sendEmail()
                }
                
               
                
                
                
                opacity = 0.0
                while(opacity<=1.0)
                {
                    opacity += 0.000002
                }
               // loadProfile = true
                
               
                opacity2 = 0.0
                while(opacity2<=1.0)
                {
                    opacity2 += 0.000002
                }
                var time = 0.0
                while(time <= 1.0)
                {
                    time += 0.000002
                }
                while(opacity2>=0.0)
                {
                    opacity2 -= 0.000002
                }
                loadProfile = true
                
                
                
                
            }
         
            
        }
        
        
        task.resume()
        
    }
        
        
}
    

struct Load_Previews: PreviewProvider {
    static var previews: some View {
        Load(email: "")
    }
}
