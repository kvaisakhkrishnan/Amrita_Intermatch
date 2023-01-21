
//
//  ContentView.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 09/11/22.
//

import SwiftUI
import SwiftSMTP

let smtp = SMTP(
    hostname: "smtp.gmail.com",
    email: "kvaisakhkrishnan@gmail.com",
    password: "pgrbcxabxctsnesi"
)

struct RegisterView: View {
    
    @State var pass : Bool = false
    @State var errorMessage : String = ""
    @State var wrongEmail = false
    @State var otp = 0
    @State var userName = ""
    @State var password = ""
    @State var email = ""
   @State var loading = false
    @State var alertShow = false
    @State var emptyField = false
    @State var firstName = ""
    @State var lastName = ""
    @State var goToOtp = false
    @State var role = "F"
    
   
    
    var body: some View {
        
        
            if(goToOtp)
        {
               
                OTPView(userName: userName, otp: otp, firstName: firstName, email: email, password: password, lastName: lastName, interests: [""], role: role, aboutMe: "", github: "", linkedin: "")
                
            }
        
        else
        {
            NavigationView
            {
                
                ZStack{
                    
                    VStack
                    {
                        
                        Image("Mobile login-pana")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        
                        Text("Register")
                            .font(.title)
                            
                            
                        
                        
                        
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
                            
                            TextField(text: $email, prompt: Text("Amrita Email")) {
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
                                    
                                        .frame(maxWidth: .infinity)
                                        .font(.headline)
                                    
                                    
                                    
                                        .padding(10)
                                    
                                    
                                        .foregroundColor(.white)
                                    
                                    
                                       
                                       
                                }
                                .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                                .cornerRadius(10)
                                Spacer()
                                
                                
                                
                                
                                
                                
                                
                            }
                            
                            VStack{
                                Text("Already Registered ?")
                                    .padding(.top,20)
                                NavigationLink(destination: ContentView() .navigationBarBackButtonHidden(true)) {
                                    
                                    Text("     LOGIN")
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                        .font(.headline)
                                        
                                    
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
            
            .alert(errorMessage , isPresented: $alertShow) {
                Button("OK", role: .cancel) { alertShow = false}
            }
            .alert("Missing Field", isPresented: $emptyField) {
                Button("OK", role: .cancel) { emptyField = false}
            }
            .alert("Invalid Amrita Email", isPresented: $wrongEmail) {
                Button("OK", role: .cancel) { wrongEmail = false}
            }
            
            .alert("Password should be minimum 6 characters long", isPresented: $pass) {
                Button("OK", role: .cancel) { pass = false}
            }
           
            
        
            .onAppear()
            {
                initialize()
                
            }
       
        }
            
        
        

    }
    
    
    func initialize()
    {
        userName = ""
        password = ""
        email = ""
       loading = false
        alertShow = false
        emptyField = false
        firstName = ""
        lastName = ""
        goToOtp = false
        role = "F"
    }
    
    func registerUser()
    {
        if(userName == "" || password == "" || firstName == "" || lastName == "" || email == "")
        {
            emptyField = true
            
        }
        
        else if(!email.contains("amrita.edu"))
        {
            wrongEmail = true
        }
        
        
        else if(password.count < 6)
        {
            pass = true
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
             "filter": [ "$or" : [ ["userName": userName], ["official" : email]]]
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
                    
                    let data = responseJSON["document"]!
                    let user = data["userName"] as! String
                    if(user == userName)
                    {
                        errorMessage = "Username already taken"
                    }
                    else
                    {
                        errorMessage = "Amrita eMail already registered"
                    }
                    loading = false
                    alertShow = true
                    
                }
                else
                {
                    loading = false
                    goToOtp = true
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
