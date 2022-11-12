//
//  ExpandProject.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 11/11/22.
//

import SwiftUI

struct ExpandProject: View {
    @State var pid : String
    @State var pname : String
    @State var pfaculty : String
    @State var keywords : [String]
    @State var desc : String
    @State var published : String
    @State var match : Double
    
    let rows = [
            GridItem(.fixed(40)),
            GridItem(.fixed(40))
            
        ]
    var body: some View {
        
        ScrollView{
            VStack{
                
               
                Text(pname)
                    .font(.title)
                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .padding(.top,10)
               
                   
                
               
                        
                    
                    Image(systemName: "heart.fill")
                        .padding(.trailing,45)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.system(size: 35))
                        .foregroundColor(.red)
                    
                
                
                Text("-- "+pfaculty)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                    .padding(.top,2)
                
                
                
                
                Text("Published On: "+published)
                
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))
                
                ProgressView(value: match/100)
                {
                    Text("Match : "+String(match)+"%")
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
        }}
}

struct ExpandProject_Previews: PreviewProvider {
    static var previews: some View {
        ExpandProject(pid: "", pname: "", pfaculty: "", keywords: [""], desc: "", published: "",match: 0.0)
    }
}
