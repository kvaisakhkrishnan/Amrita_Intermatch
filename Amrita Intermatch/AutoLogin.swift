//
//  AutoLogin.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 23/11/22.
//

import SwiftUI
import LocalAuthentication

struct AutoLogin: View {
    @State var user: String
    @State var password : String
    @State var loading = false
    var body: some View {
        
        if(loading == true)
        {
            Load(userName: user)
        }
        
        else{
            VStack{
                Image("Search-rafiki")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                
                
                
                
                
                ProgressView()
                    .scaleEffect(1.2)
                    .padding(15)
                    .background(Color(red: 225/255, green: 225/255, blue: 225/255))
                    .cornerRadius(12)
                
                Text("We found you!")
                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                    .font(.largeTitle)
                
                
                
                
            }
            .onAppear()
            {
                authenticate()
            }
        }
    }
    func authenticate()
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
         "filter": [ "userName": user, "password" : password ]
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
                if(reply["userName"] as! String == user)
                {
                  
                    loading = true
                    
                }
                
                
                
            }
           
        }
        
        
        task.resume()
        
    }
}

struct AutoLogin_Previews: PreviewProvider {
    static var previews: some View {
        AutoLogin(user: "", password: "")
    }
}
