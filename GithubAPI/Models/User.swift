//
//  User.swift
//  GithubAPI
//
//  Created by tauta on 6/30/19.
//  Copyright © 2019 kamalqawlaq. All rights reserved.
//

import Foundation

struct User: Codable {
  var username: String
  var id: Int
  var repositoriesURL: String
  var avatarURL: String
  
  enum CodingKeys: String, CodingKey {
    case username = "login"
    case repositoriesURL = "repos_url"
    case avatarURL = "avatar_url"
    case id
  }

  
}
