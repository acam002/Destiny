//
//  ViewController.swift
//  Destiny
//
//  Created by Alberto Camacho on 11/9/19.
//  Copyright © 2019 Alberto Camacho. All rights reserved.
//

import UIKit

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let player = try? newJSONDecoder().decode(Player.self, from: jsonData)

import Foundation

// MARK: - Player
struct PlayerData: Codable {
    let players: [Player]
    let errorCode, throttleSeconds: Int
    let errorStatus, message: String
    let messageData: MessageData

    enum CodingKeys: String, CodingKey {
        case players = "Response"
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

// MARK: - PlayerElement
struct Player: Codable {
    let iconPath: String
    let crossSaveOverride: Int
    let isPublic: Bool
    let membershipType: Int
    let membershipID, displayName: String

    enum CodingKeys: String, CodingKey {
        case iconPath = "iconPath"
        case crossSaveOverride = "crossSaveOverride"
        case isPublic = "isPublic"
        case membershipType = "membershipType"
        case membershipID = "membershipId"
        case displayName = "displayName"
    }
}


class ViewController: UIViewController {
    private var player: [Player] = [] {
        didSet {
            print(player)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        makeRequest { response in
            self.player = response
            //print(self.player)
        }
    }
    
    func makeRequest(completion: @escaping (([Player]) -> Void)) {
        var request = URLRequest(url: URL(string: "https://www.bungie.net/Platform/Destiny2/SearchDestinyPlayer/-1/Albyrt/")!)
        request.addValue("2b0ee5d41d674109b59e7d0ecf4f9aa1", forHTTPHeaderField: "X-API-KEY")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data
                else {
                    // Handle error
                    completion([])
                    return
            }
            do {
                let playerData = try JSONDecoder().decode(PlayerData.self, from: data)
                let players = playerData.players
                
                completion(players) // pass closureResponse
                
            } catch let error{
                completion([])
                print(error)
            }
        }.resume()
    }
}

