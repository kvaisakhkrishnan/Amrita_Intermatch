//
//  ExpandProject.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 18/11/22.
//

import SwiftUI
import SwiftSMTP

struct ShowProject: View {
    
    @Environment(\.dismiss) var dismiss
    
    
    @State var pid : String
    @State var pname : String
    @State var pfaculty : String
    @State var keywords : [String]
    @State var desc : String
    @State var loading = false
    @State var show = false
    @AppStorage("skip_user") var skip_user = ""
   
    
    let rows = [
            GridItem(.fixed(40)),
            GridItem(.fixed(40))
            
        ]
    var body: some View {
        ZStack{
            
            ScrollView{
                VStack{
                    
                    
                    Text(pname)
                        .font(.title)
                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    Text("-- "+pfaculty)
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                        .padding(.top,2)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    Text("KEYWORDS")
                        .fontWeight(.bold)
                        .padding(.top,1)
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                    
                    LazyHGrid(rows: rows) {
                        
                        
                        
                        
                        ForEach(keywords, id:\.self){value in
                            Text(value)
                                .padding(10)
                                .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                                .foregroundColor(.white)
                                .cornerRadius(30)
                        }
                        
                        
                    }
                    
                    
                    
                    VStack{
                        
                        Text("DESCRIPTION")
                            .padding(.top,50)
                            .padding(.leading)
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text(desc)
                            .foregroundColor(.white)
                            .padding()
                            .padding(.bottom,20)
                        
                        
                        Button {
                            
                            notify()
                            sendEmail()
                            
                        } label: {
                            Text("NOTIFY FACULTY")
                                .fontWeight(.bold)
                                .padding(.horizontal,50)
                                .padding(.vertical,8)
                            
                                .background(.white)
                                .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                .cornerRadius(10)
                                .padding(.bottom,50)
                                .font(.title3)
                            
                            
                            
                        }
                        
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                    .cornerRadius(30)
                    
                    
                    
                }
            }
            .alert("Faculty Notified Succesfully", isPresented: $show) {
                Button("OK", role: .cancel) { show = false
                    dismiss()
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
    
    func notify()
    {
        loading = true
        let headers = [
            "Content-Type": "application/json",
            "Access-Control-Request-Headers": "*",
            "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
        ]
        
        // prepare json data
        let json: [String: Any] =
        ["collection": "Interested",
         "database": "Interconnect",
         "dataSource": "Cluster0",
         "document" : ["pid" : pid, "email" : skip_user, "status" : false]
                   
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
               
                
            }
        }
    
            
        task.resume()
        
        
        
        
    }
    func sendEmail()
    {
        loading = true
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
            let sender = Mail.User(name: "Amrita Intermatch", email: "kvaisakhkrishnan@gmail.com")
            let reciever = Mail.User(name: pfaculty, email: pfaculty)
           
            let mail = Mail(
                from: sender,
                to: [reciever],
                subject: "I'm Interested!",
                text: "Hi,\n\nWe have found a student, '"+skip_user+"',who is interested to work in your project '"+pname+"'.\n\nregards\nAmrita Intermatch"
            )

            smtp.send(mail) { (error) in
                if let error = error {
                    print(error)
                }
                
                
                loading = false
                show = true
                
            }
        }
        
    }
}

struct ShowProject_Previews: PreviewProvider {
    static var previews: some View {
        ShowProject(pid: "", pname: "", pfaculty: "", keywords: [""], desc: "")
    }
}
