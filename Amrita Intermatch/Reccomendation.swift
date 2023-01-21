//
//  Reccomendation.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 10/11/22.
//

import SwiftUI

struct projects{
    var pname : String
    var ptype : String
    var nstudent : String
    var faculty : String
    var tags : [String]
    var desc : String
    var match : Double
    var pid : String
}

struct Reccomendation: View {
    
    
    @AppStorage("count") var count = 0
    @State var liked = false
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var op : Double = 1.0
    @State var tag : [String]
    @State var plist : [projects] = []
    @State var email : String
    @State var loading = false
    @State var recommend : [projects] = []
    var body: some View {
        
       
            
            
        ZStack{
            
            
            
            
            
            
            VStack{
                
                if(count == 0)
                {
                    Text("No Recommendation")
                        .foregroundColor(Color(red: 185/255, green: 185/255, blue: 185/255))
                        .font(.title3)
                        .fontWeight(.regular)
                }
                
                else{
                    ZStack{
                    ForEach(recommend, id: \.self.pid) { data in
                        
                            Swipe(proj: data)
                        }
                        
                    }
                    
                    
                }
                
              
            }
            .onAppear()
            {
                
                getInterest()
                
                
            }
            
            
            
            
            if(loading){
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
    
    
    func getInterest()
    {
        if(recommend.count == 0)
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
         "filter": [ "email" : email ]
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
                tag = data["interests"] as! [String]
                loading = false
                LoadData()
                
            }
            
            
        }
        
        
        task.resume()
    }
    }
    
    
    
   
    
    
    
    func calcMatch()
    {
       
        
        loading = true
        var i = 0
        while i < plist.count{
            var match = 0.0
            for j in tag{
                if plist[i].tags.contains(j)
                {
                    match += 1
                }
            }
            match = match / (Double(plist[i].tags.count))
            plist[i].match = match * 100
           i += 1
        }
        loading = false
        
        
        
        
        while(plist.count > 0)
        {
            var large = plist[0].match
            var pos = 1
            var loc = 0
            while(pos < plist.count)
            {
                if(large < plist[pos].match)
                {
                    large = plist[pos].match
                    loc = pos
                    
                }
                pos += 1
            }
        
            if(plist[loc].match != 0){
                recommend.append(plist[loc])
            }
                plist.remove(at: loc)
            
        }
        
        count = recommend.count
        
       
        
    }
    
    
    
    func LoadData()
    {
        if(recommend.count > 0)
        {
            
        }
        
        
        else{
            
            var showed_plist: [String] = []
            
            plist = []
            loading = true
            let headers = [
                "Content-Type": "application/json",
                "Access-Control-Request-Headers": "*",
                "api-key": "ksLzIRbGlgWNcZBkKwHgWBapyhdJ6HBIyhHON5Yj1DuZh95QxOogl15Blu85Ldmv"
            ]
            
            // prepare json data
            let json: [String: Any] =
            ["collection": "Likes",
             "database": "Interconnect",
             "dataSource": "Cluster0",
             "filter" : ["email" : email]
             
            ]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/find")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: NSArray] {
                    let data = responseJSON["documents"]!
                    var i = 0
                    while i < data.count{
                        let t_data = data[i] as! NSDictionary
                        showed_plist.append(t_data["pid"] as! String)
                        i+=1
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    let json: [String: Any] =
                    ["collection": "Project",
                     "database": "Interconnect",
                     "dataSource": "Cluster0",
                     "filter" : ["email" : ["$not" : ["$eq" : email]],
                                 "pid" : ["$not" : ["$in" : showed_plist]]
                                ]
                     
                    ]
                    
                    let jsonData = try? JSONSerialization.data(withJSONObject: json)
                    
                    // create post request
                    let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/find")!
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
                        if let responseJSON = responseJSON as? [String: NSArray] {
                            let data = responseJSON["documents"]!
                            var i = 0
                            while i < data.count{
                                let temp = data[i] as! NSDictionary
                                let tpname = temp["name"] as! String
                                let tcategory = temp["category"] as! String
                                let tfaculty = temp["email"] as! String
                                let tnstudents = temp["nstudents"] as! String
                                let ttags = temp["tags"] as! [String]
                                let tdesc = temp["description"] as! String
                                let tpid = temp["pid"] as! String
                                let tdata = projects(pname: tpname, ptype: tcategory, nstudent: tnstudents, faculty: tfaculty, tags: ttags, desc: tdesc, match: 0.0, pid: tpid)
                                plist.append(tdata)
                                i+=1
                            }
                            
                            loading = false
                            
                            calcMatch()
                        }
                        
                    }
                    task.resume()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
            }
            task.resume()
            
        }
       
    }
}

struct Reccomendation_Previews: PreviewProvider {
    static var previews: some View {
        Reccomendation(tag: [""], email: "")
    }
}
