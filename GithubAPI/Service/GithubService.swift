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
  
  private let disposeBag = DisposeBag()
  
  private init(){}
  public static let shared = GithubService()
  
  func getGithubUsers() -> Observable<User> {
    
    return Observable.create { observer in
      URLSession.shared.rx.data(request: URLRequest(url: self.getAllUsersURL(page: 1, numberOfResultsPerPage: 50)))
        .subscribe(onNext: { (data) in
          
          let jsonDecoder = JSONDecoder()
          
          do {
            let users = try jsonDecoder.decode([User].self, from: data)
            
            for user in users {
              observer.onNext(user)
            }
          } catch let e {
            observer.onError(e)
          }
        }, onError: { (error) in
          observer.onError(error)
        }, onCompleted: {
          observer.onCompleted()
        })
        .disposed(by: self.disposeBag)
      
      return Disposables.create()
    }
  }
  
  func getUsersFromData(_ data: Data) -> Observable<[User]>? {
    var observable: Observable<[User]>? = nil
    
    let jsonDecoder = JSONDecoder()
    do {
      let users = try jsonDecoder.decode([User].self, from: data)
      observable = Observable<[User]>.just(users)
    } catch let e {
      print(e)
    }
    
    return observable
  }
  
  func getGithubUser(_ username: String) -> Observable<User> {
    let url = getUserRequestURL(username)
    return Observable.create { observer in
      URLSession.shared.rx.data(request: URLRequest(url: url))
        .subscribe(onNext: { (data) in
            let jsonDecoder = JSONDecoder()
            do {
              let user = try jsonDecoder.decode(User.self, from: data)
              observer.onNext(user)
            } catch let error {
              print(error)
            }
        })
        .disposed(by: self.disposeBag)
      
      return Disposables.create()
    }
  }
  
  private func getAllUsersURL(page: Int, numberOfResultsPerPage: Int) -> URL {
    var allUsersURLComponents = URLComponents(string: self.baseAPIURL)!
    let allUsersURLQueryItems = [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "per_page", value: "\(numberOfResultsPerPage)")]
    
    allUsersURLComponents.path = UserEndPoint.allUsers.rawValue
    allUsersURLComponents.queryItems = allUsersURLQueryItems
    
    
    return allUsersURLComponents.url!
  }
  
  private func getUserRequestURL(_ username: String) -> URL {
    var userRequestURLComponents = URLComponents(string: self.baseAPIURL)!
    
    userRequestURLComponents.path = UserEndPoint.allUsers.rawValue + "/\(username)"
    
    return userRequestURLComponents.url!
  }
  
  private func getUserReposURL(_ username: String) -> URL {
    var userReposURLComponents = URLComponents(string: self.baseAPIURL)!
    
    userReposURLComponents.path = UserEndPoint.allUsers.rawValue + "/\(username)/repos"
    
    return userReposURLComponents.url!
  }
  
  
  func downloadUserImage(_ imageURLString: String) -> Observable<Data> {
    let imageURL = URL(string: imageURLString)!
    let imageURLRequest = URLRequest(url: imageURL)
    
    return session.rx.data(request: imageURLRequest).asObservable()
  }
  
  func getReposOfUser(_ username: String) -> Observable<[Repository]> {
    let url = getUserReposURL(username)
    
    return Observable.create { observer in
      URLSession.shared.rx.data(request: URLRequest(url: url))
        .subscribe(onNext: { (data) in
          let jsonDecoder = JSONDecoder()
          do {
            let repos = try jsonDecoder.decode([Repository].self, from: data)
            observer.onNext(repos)
          } catch let e {
            observer.onError(e)
          }
        }, onError: { (error) in
          observer.onError(error)
        }, onCompleted: {
          observer.onCompleted()
        })
        .disposed(by: self.disposeBag)
      
      return Disposables.create()
    }
  }
}

