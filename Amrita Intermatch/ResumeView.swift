//
//  AboutMe.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 18/11/22.
//

import SwiftUI

struct ResumeView: View {
    @State var resume = ""
    @AppStorage("resume") var s_resume = ""
    @State var updating = false
    @State var showAlert = false
    @State var email : String
    var body: some View {
        ZStack{
            VStack{
                
                TextEditor(text: $s_resume)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                
                
                
                
                
                Button {
                    updateLD()
                } label: {
                    Text("UPDATE")
                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                        .font(.headline)
                        .padding(.bottom)
                    
                }
                
                
                
                
                
                
                
                
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
            .navigationTitle("Resume")
            .alert("Resume Link Updated", isPresented: $showAlert) {
                Button("OK", role: .cancel) { showAlert = false}
            }
        .onAppear(){
            checkLD()
        }
        
        
        
       
    }

    func checkLD()
    {
        if(s_resume == "")
        {
            s_resume = "Paste your Resume link"
        }
    }

    
    func updateLD()
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
             "$set":[ "resume" : s_resume]
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

struct ResumeView_Previews: PreviewProvider {
    static var previews: some View {
        ResumeView(email: "" )
    }
}
