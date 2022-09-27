//
//  SpiralToken.swift
//  Example for SpiralSDK
//
//  Created by Ron Soffer on 9/20/2022.
//

import Foundation

class SpiralToken {
    var delegate: SpiralTokenDelegate?
    var spiralToken: String?
    var isLoaded = false;
    var apiSecret = ""
    
    func fetchTokenWithAttributes(_ attributes: SpiralTokenAttributes) {
        guard let url = URL(string: "https://sandbox.getspiral.com/v1/link_tokens") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let jsonData = try JSONEncoder().encode(attributes)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(apiSecret, forHTTPHeaderField: "X-API-SECRET")
            
            URLSession.shared.dataTask(with: request) { apiData, response, error in
                if let error = error {
                    print("there was an error")
                    print(error)
                }
                guard let data = apiData else {
                    print("No data")
                    return;
                }
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        // update our UI
                        // TODO: fix the modal not showing up on the first load
                        self.spiralToken = decodedResponse.data.token
                        self.isLoaded = true
                        
                        if let d = self.delegate {
                            d.onComplete(spiralToken: decodedResponse.data.token)
                        }
                    }
                }
            }.resume()
        } catch { print(error) }
        
    }
}

struct ResponseData: Codable {
    var token: String
}

struct Response: Codable {
    var data: ResponseData
}

struct SpiralTokenAttributes: Codable {
    var mode: String?
    var skip_intro_screen: Bool?
}

protocol SpiralTokenDelegate {
    func onComplete(spiralToken: String)
}
