
//
//  ContentView.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 09/11/22.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State var userName = ""
    @State var password = ""
    @State var login = false
   @State var loading = false
    @State var alertShow = false
    @State var emptyField = false
    
   
    
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
                        
                        
                        Text("Login")
                            .font(.title)
                            .padding(.top, 50)
                            
                        
                        
                        
                        Form {
                            TextField(text: $userName, prompt: Text("Username")) {
                                Text("Username")
                            }
                            SecureField(text: $password, prompt: Text("Password")) {
                                Text("Password")
                            }
                            
                            HStack{
                                
                                Spacer()
                                
                                Button {
                                    
                                    validateLogin()
                                } label: {
                                    Text("LOGIN")
                                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                        .font(.headline)
                                       
                                }
                                Spacer()
                                
                                
                                
                                
                                
                                
                                
                            }
                            
                            
                            NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true)) {
                               
                                    Text("     REGISTER")
                                    .frame(maxWidth: .infinity)
                                    .font(.headline)
                                    
                                   
                                
                                .padding(10)
                                
                                   
                                    .foregroundColor(.white)
                                   
                            }
                           
                            
                            .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                            .cornerRadius(10)
                            
                            
                            NavigationLink(destination: ResetPassword().navigationBarBackButtonHidden(true)) {
                               
                                    Text("Forgot Password")
                                    
                                    
                                .padding(10)
                                
                                   
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
            .alert("Invalid Credentials", isPresented: $alertShow) {
                Button("OK", role: .cancel) { alertShow = false}
            }
            .alert("Missing Field", isPresented: $emptyField) {
                Button("OK", role: .cancel) { emptyField = false}
            }
        }
            
        else
        {
           Load(userName: userName)
        }
        
        
        

    }
    
    func validateLogin()
    {
        if(userName == "" || password == "")
        {
            emptyField = true
            
        }
        else{
            
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
             "filter": [ "userName": userName, "password" : password ]
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
                        login = true
                        
                        
                    }
                    
                    
                    
                }
                if(login == true){
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
