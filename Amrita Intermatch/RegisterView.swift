
//
//  ContentView.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 09/11/22.
//

import SwiftUI
import Foundation

struct RegisterView: View {
    @State var userName = ""
    @State var password = ""
    @State var email = ""
   @State var loading = false
    @State var alertShow = false
    @State var emptyField = false
    @State var firstName = ""
    @State var lastName = ""
    @State var registered = false
    @State var backToLogin = false
    @State var role = "F"
    
   
    
    var body: some View {
        
        
            if(backToLogin)
        {
                ContentView()
                
            }
        
        else
        {
            NavigationView
            {
                
                ZStack{
                    
                    VStack
                    {
                        
                        Image("amritadraw")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        
                        Text("Register")
                            .font(.title)
                            .padding(.top, 50)
                            
                        
                        
                        
                        Form {
                            
                            TextField(text: $firstName, prompt: Text("First Name")) {
                                Text("First Name")
                            }
                            
                            TextField(text: $lastName, prompt: Text("Last Name")) {
                                Text("Last Name")
                            }
                            
                            
                            TextField(text: $userName, prompt: Text("Username")) {
                                Text("Username")
                            }
                            
                            TextField(text: $email, prompt: Text("Amrita e-Mail")) {
                                Text("Username")
                            }
                            
                            SecureField(text: $password, prompt: Text("Password")) {
                                Text("Password")
                            }
                            
                            HStack{
                                
                                Spacer()
                                
                                Button {
                                    
                                    registerUser()
                                } label: {
                                    Text("REGISTER")
                                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                        .font(.headline)
                                       
                                }
                                Spacer()
                                
                                
                                
                                
                                
                                
                                
                            }
                            
                            VStack{
                                Text("Already Registered ?")
                                    .padding(.top,20)
                                NavigationLink(destination: ContentView() .navigationBarBackButtonHidden(true)) {
                                    
                                    Text("     LOGIN")
                                        .frame(maxWidth: .infinity)
                                        .font(.headline)
                                    
                                    
                                    
                                        .padding(10)
                                    
                                    
                                        .foregroundColor(.white)
                                    
                                }
                                .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                                .cornerRadius(10)
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
            .alert("Credentials already registered", isPresented: $alertShow) {
                Button("OK", role: .cancel) { alertShow = false}
            }
            .alert("Missing Field", isPresented: $emptyField) {
                Button("OK", role: .cancel) { emptyField = false}
            }
            .alert("Succesfully Registered", isPresented: $registered) {
                Button("OK", role: .cancel) { backToLogin = true}
            }
       
        }
        
        

    }
    
    func registerUser()
    {
        if(userName == "" || password == "" || firstName == "" || lastName == "" || email == "")
        {
            emptyField = true
            
        }
        else{
            
            
            loading = true
            
            
            
            let headers = [
                "Content-Type": "application/json",
                "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
            ]
            
            // prepare json data
            let json: [String: Any] =
            ["collection": "User",
             "database": "Interconnect",
             "dataSource": "Cluster0",
             "document": ["userName" : userName, "password" : password,"official" : email ]
            ]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            // create post request
            let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/insertOne")!
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
                    
                    
                    
                    
                    if(email.contains("students"))
                    {
                        role = "S"
                    }
                    
                    
                    let json: [String: Any] =
                    ["collection": "Profile",
                     "database": "Interconnect",
                     "dataSource": "Cluster0",
                     "document": ["user" : userName, "firstName" : firstName, "lastName" : lastName, "role" : role, "interests" : [], "aboutMe" : ""]
                    ]
                    
                    let jsonData = try? JSONSerialization.data(withJSONObject: json)
                    
                    // create post request
                    let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/insertOne")!
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
                        }
                        
                        
                    }
                    task.resume()
                    
                    
                    
                    registered = true
                    loading = false
                }
                else
                    
                {
                   registered = false
                    loading = false
                    alertShow = true
                }
               
                
            }
            
            
            task.resume()
            
            
            
            
        }
    }
    
    
    
   

    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
