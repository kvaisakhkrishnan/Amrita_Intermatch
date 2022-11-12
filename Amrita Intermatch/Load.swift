//
//  Tab.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 10/11/22.
//

import SwiftUI

struct Load: View {
    @State var loading = false
    @State var userName : String
    @State var loadProfile = false
    
    @State private var size = 1.5
    @State private var opacity = 0.0
    @State private var opacity2 = 0.0
    @State var dpname = ""
    
    @State var pname = "Vaisakh"
    
    
    var body: some View {
        if(loadProfile)
        {
            
            Tab(userName:userName)
                
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
    
    
    
    
    
    
    func LoadData()
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
         "filter": [ "user": userName]
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
        Load(userName: "")
    }
}
