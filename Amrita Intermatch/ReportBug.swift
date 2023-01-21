//
//  ReportBug.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 09/01/23.
//

import SwiftUI
import SwiftSMTP

struct ReportBug: View {
    
    @State private var image: Image? = Image("noselection")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @AppStorage("skip_user") var skip_user = ""
    @State var loading = false
    @State var alert1 = false
    @State var describe : String = ""
    @State var issue : String = ""
    var body: some View {
        
        ZStack
        {
            VStack{
                
                Image("3426526")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                
                
                Form{
                    
                    Section(header: Text("Feel free to tell us!"))
                    {
                        
                        
                        Text(skip_user)
                            .foregroundColor(.gray)
                        
                        
                        
                        
                    }
                    
                    Section(header: Text("In which page are you facing this issue?"))
                    {
                        TextField(text: $issue, prompt: Text("Describe the page")) {
                            Text("Describe the page")
                            
                            
                        }
                    }
                    
                    
                    Section(header: Text("Describe problem faced"))
                    {
                        TextEditor(text: $describe)
                    }
                    
                    Section(header: Text("Upload Screenshots if any"))
                    {
                        
                        
                        
                        Button(action: {
                            
                        }, label: {
                            Text("Click to load screenshot")
                                .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                        })
                            .onTapGesture { self.shouldPresentActionScheet = true }
                            .sheet(isPresented: $shouldPresentImagePicker) {
                                SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
                            }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                                ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                                    self.shouldPresentImagePicker = true
                                    self.shouldPresentCamera = true
                                }), ActionSheet.Button.default(Text("Photo Library"), action: {
                                    self.shouldPresentImagePicker = true
                                    self.shouldPresentCamera = false
                                }), ActionSheet.Button.cancel()])
                            }
                    
                        
                        
                        
                        
                        
                    }
                    
                    Section(header: Text("Selected Image"))
                    {
                        image!
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                       
                        
                    }
                    
                    Section(header: Text(""))
                    {
                        Button {
                            loading = true
                            sendData()
                            sendEmail()
                            
                            
                            
                        } label: {
                            Text("REPORT")
                                .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                    .navigationTitle("Report Bug")
                    
                    .alert("The Developer of the App will look into it shortly. Thankyou!",isPresented: $alert1)
                    {
                        Button {
                            alert1 = false
                            loading = false
                        } label: {
                            Text("OK")
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
    
    
    func sendData()
    {
        let headers = [
            "Content-Type": "application/json",
            "Access-Control-Request-Headers": "*",
            "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
        ]

        // prepare json data
        let json: [String: Any] =
        ["collection": "Report",
         "database": "Interconnect",
         "dataSource": "Cluster0",
         "document": [ "caseId" : UUID(), "user" : skip_user, "page" : issue, "desc" : describe, "image" : image!]
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
            if let _ = responseJSON as? [String: NSDictionary] {
               
                
                
                
            }
           
        }


        task.resume()
    }
    
    func sendEmail()
     {
         let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
         dispatchQueue.async{
             
             
             
             let sender = Mail.User(name: "Amrita Intermatch", email: "kvaisakhkrishnan@gmail.com")
             let reciever = Mail.User(name: "Vaisakhkrishnan K", email: "kvaisakhkrishnan@gmail.com")
             let mail = Mail(
                 from: sender,
                 to: [reciever],
                 subject: " Amrita Interatch Bug Report",
                 text: "One of our user, "+skip_user+", reported a bug.\n\nPage Description : \n"+describe+"\n\nIssue : \n"+issue+"\n\nRegards\nAmrita Intermatch"
             )

             smtp.send(mail) { (error) in
                 if let error = error {
                     print(error)
                 }
                 alert1 = true
             }
         }
        
     }
    
    
}

struct ReportBug_Previews: PreviewProvider {
    static var previews: some View {
        ReportBug()
    }
}
