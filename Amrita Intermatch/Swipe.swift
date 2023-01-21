//
//  Swipe.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 10/01/23.
//

import SwiftUI

struct Swipe: View {
    @AppStorage("count") var count = 0
    @AppStorage("skip_user") var skip_user = ""
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var offset = CGSize.zero
    @State private var color: Color = .white
    @State private var opacity : Float = 0.0
    var proj : projects
    var body: some View {
        
       
            
            ZStack{
                
                Rectangle()
                    .foregroundColor(.white)
                   
                   
                    .cornerRadius(50)
                    
                   
                
                    
                ScrollView{
                    VStack{
                        
                       
                        
                        
                        
                       
                        
                    
                        
                        
                        Text(proj.pname)
                            .font(.title)
                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .padding(.top,10)
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        Text("-- "+proj.faculty)
                            .font(.callout)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                            .padding(.top,2)
                        
                        
                        
                        
                        
                        
                        ProgressView(value: proj.match/100)
                        {
                            Text("Match : "+String(proj.match)+"%")
                        }
                        .progressViewStyle(LinearProgressViewStyle(tint:Color(red: 2/255, green: 100/255, blue: 48/255)))
                        .padding(.top,10)
                        .padding(.horizontal)
                        .padding(.bottom,10)
                        
                        
                        
                        Text("KEYWORDS")
                            .fontWeight(.bold)
                            .padding(.top,1)
                            .font(.callout)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                        
                        
                        
                        
                        LazyVGrid(columns: columns) {
                            
                            
                            
                            
                            ForEach(proj.tags, id:\.self){value in
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
                            Text(proj.desc)
                                .foregroundColor(.white)
                                .padding()
                                .padding(.bottom,20)
                            
                            
                            
                            
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                        .cornerRadius(30)
                        
                        .shadow(radius: 100)
                        
                    }
                    
                   
                    
                }
               
                
                
              
                
                
                Rectangle()
                    .foregroundColor(color)
                   
                   
                    .cornerRadius(50)
                    
                    .opacity(Double(opacity))
                
                    .shadow(radius: 100)
                
                
                
               
                
            }
        
           
           
            
        
            .offset(x: offset.width, y: offset.height * 0.4)
           .rotationEffect(.degrees(Double(offset.width / 40)))
            .gesture(
            DragGesture()
                .onChanged{ gesture in
                    offset = gesture.translation
                    withAnimation{
                        changeColor(width: offset.width)
                    }
                }
                .onEnded{ _ in
                    withAnimation{
                        swipeCard(width: offset.width)
                        changeColor(width: offset.width)
                    }
                    
                })
            
        
            
            
            
            
            
            
            
            
        
    }
    func swipeCard(width: CGFloat)
    {
        switch width{
        case -500...(-150):
            addDisLiked()
            
            offset = CGSize(width: -500, height: 0)
        case 100...500:
            addLiked()
            
            offset = CGSize(width: 500, height: 0)
        default:
            offset = .zero
        }
    }
    
    func changeColor(width: CGFloat)
    {
        switch width{
        case -500...(-130):
            color = Color(red: 130/255, green: 0/255, blue: 0/255)
            opacity = 1.0

        case 130...500:
            color = Color(red: 2/255, green: 52/255, blue: 48/255)
            opacity = 1.0
        default:
            color = .white
            opacity = 0.0
        }
        
    }
    
    
    
    
    
    func addDisLiked()
    {
        count -= 1
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
         "document" : ["pid" : proj.pid,"email" : skip_user,"match" : proj.match, "liked" : false, "moved" : false]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/insertOne")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let _: Void = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if responseJSON is [String: Any] {
               
            }
        } .resume()
        
    }
    
   
    func addLiked()
    {
        count -= 1
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
         "document" : ["pid" : proj.pid,"email" : skip_user,"match" : proj.match, "liked" : true, "moved" : false]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://data.mongodb-api.com/app/data-etamo/endpoint/data/v1/action/insertOne")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let _: Void = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if responseJSON is [String: Any] {
               
            }
        } .resume()
        
    }
    
    
    
    
    
}

struct Swipe_Previews: PreviewProvider {
    static var previews: some View {
        Swipe(proj: projects(pname: "", ptype: "", nstudent: "", faculty: "", tags: [""], desc: "", match: 0.0, pid: ""))
    }
}
