//
//  OTPView.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 20/11/22.
//

import SwiftUI
import SwiftSMTP




struct OTPView: View {
    
    
    
    @AppStorage("skip_user") var skip_user = ""
    @AppStorage("skip_password") var skip_password = ""
    
    
    @State var alert1 = false
    @State var alert2 = false
    @State var userName : String
    @State var loading = false
    @State var otp : Int
    @State var firstName : String
    @State var email : String
    @State var sotp : String = ""
    @State var totp : Int = 0
    @State var time = 300
    @State var success = false
    @State var wrongMail = false
    @State var password : String
    @State var lastName : String
    @State var interests : [String]
    @State var role : String
    @State var aboutMe : String
    @State var github : String
    @State var linkedin : String
    var body: some View {
        
        
        
        ZStack{
            
            if(success == true)
            {
                UserDetails(email: email)
            }
            else{
                
                
                if(wrongMail == false)
                {
                    
                    
                    
                    VStack
                    {
                        Image("2846317")
                            .resizable()
                            .aspectRatio(contentMode: .fit
                            )
                        
                        Text("Verify OTP")
                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                            .font(.title)
                            .fontWeight(.medium)
                            .padding(.bottom,30)
                        
                        
                        List{
                            
                            
                            
                            if(time != 0){
                                SecureField(text: $sotp, prompt: Text("0 0 0 0 0 0")) {
                                    Text("OTP")
                                    
                                }
                                .multilineTextAlignment(.center)
                                .textContentType(.oneTimeCode)
                                   .keyboardType(.numberPad)
                                
                                Button {
                                    verifyOTP()
                                } label: {
                                    
                                    Text("VERIFY")
                                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .fontWeight(.medium)
                                }
                            }
                            
                            if(time >= 240){
                                
                                Button {
                                    verifyOTP()
                                } label: {
                                    
                                    Text("Send OTP Again")
                                        .foregroundColor(Color(red: 185/255, green: 185/255, blue: 185/255))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .fontWeight(.medium)
                                }
                                .disabled(true)
                                
                                
                                
                            }
                            else
                            {
                                
                                Button {
                                    sendOTP()
                                } label: {
                                    
                                    Text("Send OTP Again")
                                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    
                                }
                                
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        Text("Validity : "+String(time)+" seconds")
                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top,20)
                            .padding(.bottom,10)
                        
                        
                        Button {
                            resetMail()
                        } label: {
                            
                            Text("Wrong Amrita eMail ?")
                                .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                                .fontWeight(.medium)
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                    }.onAppear()
                    {   sendOTP()
                        startCount()
                    }
                    .alert("OTP field empty",isPresented: $alert1)
                    {
                        Button {
                            alert1 = false
                        } label: {
                            Text("OK")
                        }

                    }
                    
                    .alert("Invalid OTP",isPresented: $alert2)
                    {
                        Button {
                            alert2 = false
                        } label: {
                            Text("OK")
                        }

                    }
                    
                    
                    
                }
                    
                
                
                else
                
                {
                    VStack
                    {
                        Image("Email capture-bro")
                            .resizable()
                            .aspectRatio(contentMode: .fit
                            )
                        Text("Change Email")
                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                            .font(.title)
                            .fontWeight(.medium)
                        
                        
                        
                        List{
                            
                            
                            
                            
                            TextField(text: $email, prompt: Text("Enter Amrita Email")) {
                                Text("Mail")
                                
                            }
                            .multilineTextAlignment(.center)
                            
                            Button {
                                
                                wrongMail = false
                            } label: {
                                
                                Text("SEND OTP")
                                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .fontWeight(.medium)
                            }
                            
                        }
                        
                        
                        
                    }
                }
                
                
                
                
            }
            
            
            if(loading == true)
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
        
       
        
    }
    
    func resetMail()
    {
        wrongMail = true
    }
    
    
    func sendOTP()
    {
       
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
            
            
            
            let sender = Mail.User(name: "Amrita Intermatch", email: "kvaisakhkrishnan@gmail.com")
            let reciever = Mail.User(name: firstName, email: email)
            otp = Int.random(in: 100000...999999)
            let mail = Mail(
                from: sender,
                to: [reciever],
                subject: "Amrita Intermatch Email Verification",
                text: "Hi "+firstName+",\n\nThanks for starting the new Amrita Intermatch account process. We want to make sure it's really you. Please enter the following verification code when prompted.\n\nOTP : "+String(otp)+"\n\nRegards\nAmrita Intermatch"
            )

            smtp.send(mail) { (error) in
                if let error = error {
                    print(error)
                }
            }
        }
        if(time == 0)
        {
            time = 300
            startCount()
        }
    }
        
    
    
    func verifyOTP()
    {
       
        if(sotp == "")
        {
            alert1 = true
        }
        else if(Int(sotp)! != otp)
        {
            alert2 = true
        }
        
     
        else if(Int(sotp)! == otp)
        {
         
            loading = true
            if(email.contains("students"))
            {
                role = "S"
            }
            
           
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
             "document" : ["email" : email, "firstName" : firstName, "lastName" : lastName, "interests" : interests, "role" : role, "aboutMe" : aboutMe, "github" : github, "linkedin" : linkedin]
                       
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
                if responseJSON is [String: Any] {
                   
                    
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
                     "document" : ["userName" : userName, "password" : password, "official" : email, "memory" : 0.0]
                               
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
                        if responseJSON is [String: Any] {
                           
                            
                           loading = false
                            success = true
                            
                        }
                    }
                
                        
                    task.resume()
                    
                    
                    
                  
                    
                }
            }
        
                
            task.resume()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
         
     }
    }
    
    func startCount()
    {

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               time -= 1
                DispatchQueue.main.asyncAfter(deadline: .now()){
                    if(time>0){
                        startCount()
                    }
                }
            }
        
    }
    
        
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(userName: "", otp: 0, firstName: "", email: "", password: "",lastName : "", interests: [""], role: "", aboutMe: "",github: "",linkedin: "")
    }
}
