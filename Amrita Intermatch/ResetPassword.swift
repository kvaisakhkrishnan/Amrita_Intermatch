
//
//  ContentView.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 09/11/22.
//

import SwiftUI
import Foundation

struct ResetPassword: View {
    @State var userName = ""
    @State var email = ""
    @State var login = false
   @State var loading = false
    @State var alertShow = false
    @State var emptyField = false
    @State var npassword = ""
    @State var cpassword = ""
    @State var enableReset = true
    @State var userFound = false
    @State var pname = ""
    @State var alertShowNew = false

    
   
    
    var body: some View {
        
        if(login == false)
        {
            NavigationView
            {
                
                ZStack{
                    
                    VStack
                    {
                        
                        Image("amritadraw")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        
                        Text("Reset Password")
                            .font(.title)
                            .padding(.top, 50)
                            
                        
                        
                        
                        if(userFound == false)
                        {
                            
                            Form {
                                TextField(text: $userName, prompt: Text("Username")) {
                                    Text("Username")
                                }
                                
                                
                                
                                TextField(text: $email, prompt: Text("Amrita e-Mail")) {
                                    Text("Amrita e-Mail")
                                }
                                
                                
                                HStack{
                                    
                                    Spacer()
                                    
                                    Button {
                                        
                                        searchUser()
                                    } label: {
                                        Text("SEARCH")
                                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                            .font(.headline)
                                           
                                    }
                                    Spacer()
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                                NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                                   
                                        Text("     BACK TO LOGIN")
                                        .frame(maxWidth: .infinity)
                                        .font(.headline)
                                        
                                       
                                    
                                    .padding(10)
                                    
                                       
                                        .foregroundColor(.white)
                                       
                                }
                               
                                
                                .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                                .cornerRadius(10)
                                
                                
                              
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                            }
                            
                        }
                        
                        
                        
                        else
                            
                        {
                            
                            
                            Form {
                                
                                Text("Welcome, "+pname)
                                TextField(text: $npassword, prompt: Text("New Password")) {
                                    Text("New Password")
                                }
                               
                                .onChange(of: npassword) { newValue in
                                                   checkEquity()
                                               }
                                
                                
                                TextField(text: $cpassword, prompt: Text("Confirm New Password")) {
                                    Text("Confirm New Password")
                                }
                                .onChange(of: cpassword) { newValue in
                                                   checkEquity()
                                               }
                               
                                
                                
                                HStack{
                                    
                                    Spacer()
                                    
                                    Button {
                                        
                                        resetPassword()
                                    } label: {
                                        Text("RESET")
                                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                            .font(.headline)
                                           
                                    }
                                    .disabled(enableReset)
                                    Spacer()
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                .alert("Password Changed", isPresented: $alertShowNew) {
                                    Button("OK", role: .cancel) { alertShowNew = false
                                        login = true
                                    }
                                }
                                
                                
                                
                            }
                           
                            
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
            }
            .alert("User not found", isPresented: $alertShow) {
                Button("OK", role: .cancel) { alertShow = false}
            }
            .alert("Missing Field", isPresented: $emptyField) {
                Button("OK", role: .cancel) { emptyField = false}
            }
        }
            
        else
        {
            ContentView()
        }
        
        
        

    }
    func resetPassword()
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
         "filter":  ["userName": userName],
         "update" : [
            "$set":["password":npassword]
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
            if let responseJSON = responseJSON as? [String: Any] {
               
                
                alertShowNew = true
                
            }
        }
    
            
        task.resume()
    }
    
    
    func checkEquity()
    {
        if (npassword == "" && cpassword == ""){
            enableReset = true
        }
       
        else
        {
            if(npassword == cpassword)
            {
                enableReset = false
            }
            else
            {
                enableReset = true
            }
        }
    }
    
    
    func searchUser()
    {
       
            if(userName == "" || email == "")
        {
                emptyField = true
                
            }
        else
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
             "filter": [ "userName": userName, "official" : email ]
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
                    if(reply["userName"] as! String == userName)
                    {
                        userFound = true
                        
                        
                    }
                    
                    
                    
                }
                if(userFound == true){
                    
                    
                    let json2: [String: Any] =
                    ["collection": "Profile",
                     "database": "Interconnect",
                     "dataSource": "Cluster0",
                     "filter": [ "user": userName]
                    ]
           
                    
                    
                    let jsonData2 = try? JSONSerialization.data(withJSONObject: json2)
                    
                    // create post request
                    let url2 = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/findOne")!
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
                        
                        if let responseJSON = responseJSON as? [String: NSDictionary] {
                            let reply = responseJSON["document"]!
                            let fname = reply["firstName"] as! String
                            let lname = reply["lastName"] as! String
                            pname = fname + " " + lname
                           
                            
                            
                        }
                        
                        
                    }
                    task2.resume()
                    
                    loading = false
                }
                else
                {
                    alertShow = true
                    loading = false
                }
                
            }
            
            
            task.resume()
            
            
            
            
            
        }
            
        
    }
    
}

struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword()
    }
}
