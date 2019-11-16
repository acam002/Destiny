//
//  ViewController.swift
//  Destiny
//
//  Created by Alberto Camacho on 11/9/19.
//  Copyright © 2019 Alberto Camacho. All rights reserved.
//

import UIKit

// MARK: - Profile
struct Profile: Codable {```
    let response: [Response]
    let errorCode, throttleSeconds: Int
    let errorStatus, message: String
    let messageData: MessageData
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case errorCode = "ErrorCode"
        case throttleSeconds = "ThrottleSeconds"
        case errorStatus = "ErrorStatus"
        case message = "Message"
        case messageData = "MessageData"
    }
}

// MARK: - MessageData
struct MessageData: Codable {
}

// MARK: - Response
struct Response: Codable {
    let iconPath: String
    let crossSaveOverride: Int
    let isPublic: Bool
    let membershipType: Int
    let membershipID, displayName: String
    
    enum CodingKeys: String, CodingKey {
        case iconPath, crossSaveOverride, isPublic, membershipType
        case membershipID = "membershipId"
        case displayName
    }
}


class ViewController: UIViewController {
    private var profile: Profile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        makeRequest {response in
            self.profile = response
            print(response)
        }
    }
    
    func makeRequest(completion: @escaping ((Profile?) -> Void)) {
        var request = URLRequest(url: URL(string: "https://www.bungie.net/Platform/Destiny2/SearchDestinyPlayer/-1/Albyrt/")!)
        request.addValue("2b0ee5d41d674109b59e7d0ecf4f9aa1", forHTTPHeaderField: "X-API-KEY")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data
                else {
                    // Handle error
                    completion(nil)
                    return
            }
            do {
                let profile = try JSONDecoder().decode(Profile.self, from: data)
                completion(profile) // pass closureResponse
                
            } catch let error{
                completion(nil)
                print(error)
            }
        }.resume()
    }
}

