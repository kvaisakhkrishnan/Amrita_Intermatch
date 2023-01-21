
//
//  ContentView.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 09/11/22.
//



import SwiftUI
import Foundation


struct ContentView: View {

    @State private var showKeyboard: Bool = false
    @State var error_code : String = ""
    @State var show_error = false
    @State var userName = ""
    @State var password = ""
    @State var login = false
    @State var loading = false
    @State var alertShow = false
    @State var emptyField = false

    @AppStorage("skip_user") var skip_user = ""
    @AppStorage("skip_password") var skip_password = ""

    var body: some View {


        ZStack
        {


            if(show_error == true)
            {
                VStack{
                    Image(systemName: "wifi.exclamationmark")
                        .font(.system(size: 100))
                        .padding(.bottom)
                        .foregroundColor(.blue)

                    Text("No Internet or Server Down")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.bottom)


                    Button {

                        tryAgain()

                    } label: {
                        Text("Try Again")

                    }

                }
            }



        else if(login == false)
        {
            NavigationView
            {

                ZStack{

                    VStack
                    {
                        VStack{

                        Image("2853458")
                            .resizable()
                            .aspectRatio(contentMode: .fit)



                        Text("Login")
                            .font(.title)




                    }
                        .onTapGesture {
                                   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                               }

                        Form {




                            TextField(text: $userName, prompt: Text("Username")) {
                                Text("Username")
                            }
                            SecureField(text: $password, prompt: Text("Password")) {
                                Text("Password")
                            }

                            HStack{

                                Spacer()

                                Button {

                                    validateLogin()
                                } label: {
                                    Text("LOGIN")
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding(10)

                                }
                                .background(Color(red: 2/255, green: 52/255, blue: 48/255))
                                .cornerRadius(10)
                                Spacer()







                            }





                            NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true)) {

                                Text("    REGISTER")
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(Color(red: 2/255, green: 52/255, blue: 48/255))

                                    .font(.headline)






                                    .foregroundColor(.white)

                            }





                            NavigationLink(destination: ResetPassword().navigationBarBackButtonHidden(true)) {

                                Text("Forgot Password")



                                    .padding(10)


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


            .alert("Invalid Credentials", isPresented: $alertShow) {
                Button("OK", role: .cancel) { alertShow = false}
            }
            .alert("Missing Field", isPresented: $emptyField) {
                Button("OK", role: .cancel) { emptyField = false}
            }

            .onAppear()
            {
                initialize()

            }

        }

        else
        {
            Load(email: skip_user)
        }




    }




}


    func tryAgain()
    {
        show_error = false

    }


    func initialize()
    {
        userName = ""
        password = ""
        login = false
       loading = false
        alertShow = false
        emptyField = false

    }

    func validateLogin()
    {


        if(userName == "" || password == "")
        {
            emptyField = true

        }
        else{

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
             "filter": [ "userName": userName, "password" : password ]
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
                if let error = error {
                    error_code = error.localizedDescription
                    show_error = true

                        return
                      }
                let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let responseJSON = responseJSON as? [String: NSDictionary] {
                    let reply = responseJSON["document"]!
                    if(reply["userName"] as! String == userName)
                    {
                        login = true
                        skip_user = reply["official"] as! String
                        skip_password = password


                    }



                }
                if(login == true){

                    loading = false
                }
                else
                {
                    alertShow = true
                    loading = false
                }

            }


            task.resume()






        }




    }



}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




