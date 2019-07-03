//
//  GithubUsersService.swift
//  GithubAPI
//
//  Created by kamal on 7/1/19.
//  Copyright © 2019 kamalqawlaq. All rights reserved.
//

import RxSwift

class GithubService {
  
  private let session = URLSession.shared
  private let baseAPIURL = "https://api.github.com"
  
  private init(){}
  public static let shared = GithubService()
  
  func getGithubUsers() -> Observable<Data> {
    return session.rx
      .data(request: URLRequest(url: getAllUsersURL(page: 1, numberOfResultsPerPage: 20)))
      .asObservable()
  }
  
  private func getAllUsersURL(page: Int, numberOfResultsPerPage: Int) -> URL {
    var allUsersURLComponents = URLComponents(string: self.baseAPIURL)!
    let allUsersURLQueryItems = [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "per_page", value: "\(numberOfResultsPerPage)")]
    
    allUsersURLComponents.path = UserEndPoint.allUsers.rawValue
    allUsersURLComponents.queryItems = allUsersURLQueryItems
    
    
    return allUsersURLComponents.url!
  }
  
  
  func downloadUserImage(_ imageURLString: String) -> Observable<Data> {
    let imageURL = URL(string: imageURLString)!
    let imageURLRequest = URLRequest(url: imageURL)
    
    return session.rx.data(request: imageURLRequest).asObservable()
  }
}

