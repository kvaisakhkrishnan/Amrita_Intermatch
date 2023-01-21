//
//  AboutMe.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 18/11/22.
//

import SwiftUI

struct AboutMe: View {
    @AppStorage("aboutMe") var s_aboutMe = ""
    @State var updating = false
    @State var showAlert = false
    @State var aboutMe : String
    @State var email : String
    var body: some View {
       
            VStack{
                
                TextEditor(text: $s_aboutMe)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        
                     
                   
                
                
                    
                    Button {
                        updateAbout()
                    } label: {
                        Text("UPDATE")
                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                            .font(.headline)
                            .padding(.bottom)
                        
                    }
               
                   
               
                if(updating){
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
            
                .navigationTitle("About Me")
                .alert("About Me Updated", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { showAlert = false}
                
        }
        
        .onAppear(){
            checkAboutMe()
        }
        
    }
    func checkAboutMe()
    {
        if(s_aboutMe == "")
        {
            s_aboutMe = "Tell something about yourself."
        }
    }
    func updateAbout()
    {
      updating = true
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
             "$set":["aboutMe" : s_aboutMe]
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
                
             updating = false
                 showAlert = true
                 
             }
         }
     
             
         task.resume()
    }
    
        
}

struct AboutMe_Previews: PreviewProvider {
    static var previews: some View {
        AboutMe(aboutMe : "", email : "")
    }
}
