//
//  ViewController.swift
//  Destiny
//
//  Created by Alberto Camacho on 11/9/19.
//  Copyright © 2019 Alberto Camacho. All rights reserved.
//

import UIKit
import Combine

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

enum PlayerError: Error {
    case error
}


class ViewController: UIViewController {
    
    //private var publisher: AnyPublisher<SomeObject, Error>()
    
    private var player: PlayerData? {
        didSet {
            print("!!!!", player)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchCombine()
            .sink(receiveCompletion: { completion in
                print(">>>>", completion)
            }) { (playerData) in
                self.player = playerData
                let x = playerData.players.first?.crossSaveOverride
        }
    }
    
    func fetchCombine() -> AnyPublisher<PlayerData, PlayerError> {
        var request = URLRequest(url: URL(string: "https://www.bungie.net/Platform/Destiny2/SearchDestinyPlayer/-1/Albyrt/")!)
        request.addValue("2b0ee5d41d674109b59e7d0ecf4f9aa1", forHTTPHeaderField: "X-API-KEY")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: PlayerData.self, decoder: JSONDecoder())
            .mapError({ (error) -> PlayerError in
                PlayerError.error
            })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

