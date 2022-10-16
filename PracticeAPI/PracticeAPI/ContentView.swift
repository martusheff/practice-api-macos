//
//  ContentView.swift
//  PracticeAPI
//
//  Created by andronick martusheff on 10/15/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var key1: String = ""
    @State var key2: String = ""
    @State var key3: String = ""
    @State var key4: String = ""
    @State var key5: String = ""
    @State var value1: String = ""
    @State var value2: String = ""
    @State var value3: String = ""
    @State var value4: String = ""
    @State var value5: String = ""
    
    @State var url: String = ""
    @State var requestBody: [String:AnyHashable] = [:]
    
    @State var responseCode: Int = -1
    @State var responseBody: String = ""
    @State var responseError: String = ""
    
    var body: some View {
        GeometryReader { gmt in
            VStack {
                
                HStack {
                    Image("siren")
                        .resizable()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading) {
                        Text("OpenAPIGUI Practice").font(.title)
                        Text("Starting small, for something big.").font(.headline)
                    }
                }
                KeyValueView(key: $key1, value: $value1)
                KeyValueView(key: $key2, value: $value2)
                KeyValueView(key: $key3, value: $value3)
                KeyValueView(key: $key4, value: $value4)
                KeyValueView(key: $key5, value: $value5)
                TextField("URL", text: $url)
                HStack {
                    Button { fillDefault() } label: { Text("Defaults") }
                    Button { clearAll() } label: { Text("Clear All") }
                    Button { getRequest(url: url) } label: { Text("Get") }
                    Button { buildRequestBody() } label: { Text("Build Post Request Body") }
                    Button { postRequest(url: url, body: requestBody) } label: { Text("Post") }
                    
                }
                HStack {
                    ScrollView {
                        Text(responseBody)
                    }
                    .frame(width: gmt.size.width/2)
                    VStack {
                        Text("\(responseCode)")
                        Text(responseError)
                    }
                    .frame(width: gmt.size.width/2)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
            }
        }
        
        .padding()
    }
    func fillDefault() {
        key1 = "name"
        value1 = randomString(length: 8)
        key2 = "name"
        value2 = randomString(length: 5)
        key3 = "name"
        value3 = randomString(length: 12)
        key4 = "name"
        value4 = randomString(length: 3)
        key5 = "name"
        value5 = randomString(length: 9)
        url = "https://my-json-server.typicode.com/martusheff/practice-api-macos/profile"
    }
    
    func clearAll() {
        key1 = ""
        key2 = ""
        key3 = ""
        key4 = ""
        key5 = ""
        value1 = ""
        value2 = ""
        value3 = ""
        value4 = ""
        value5 = ""
        url = ""
        requestBody = [:]
    }
    
    func buildRequestBody() {
        if !key1.isEmpty {
            requestBody[key1] = value1
        }
        if !key2.isEmpty {
            requestBody[key2] = value2
        }
        if !key3.isEmpty {
            requestBody[key3] = value3
        }
        if !key4.isEmpty {
            requestBody[key4] = value4
        }
        if !key5.isEmpty {
            requestBody[key5] = value5
        }
    }
    
    func postRequest(url: String = "", body: [String:AnyHashable]) {
        // HAVE TO SET THE
        // METHOD, BODY, HEADERS
        
        guard let URL = URL(string: url) else { return }
        
        var request = URLRequest(url: URL)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                responseCode = response.statusCode
                print("RESPONSE: \(response.statusCode)")
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                responseBody = dataString
                print("RESPONSE DATA: \(dataString)")
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(response)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func getRequest(url: String = "") {
        guard let URL = URL(string: url) else { return }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                responseError = error.localizedDescription
                print("ERROR: \(error.localizedDescription)")
            }
            
            if let response = response as? HTTPURLResponse {
                responseCode = response.statusCode
                print("RESPONSE: \(response.statusCode)")
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                responseBody = dataString
                print("RESPONSE DATA: \(dataString)")
            }
        }
        task.resume()
    }
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
