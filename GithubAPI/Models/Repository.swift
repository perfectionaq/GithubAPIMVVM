//
//  Repository.swift
//  GithubAPI
//
//  Created by kamalqawlaq on 03/07/2019.
//  Copyright © 2019 kamalqawlaq. All rights reserved.
//

struct Repository: Codable {
  var ownerName: String?
  
  var name: String
  var description: String?
  
  enum CodingKeys: String, CodingKey {
    case name
    case description
  }
}
