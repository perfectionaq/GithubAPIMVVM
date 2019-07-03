//
//  UserViewModel.swift
//  GithubAPI
//
//  Created by tauta on 6/30/19.
//  Copyright © 2019 kamalqawlaq. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class UsersViewModel {
  
  private let disposeBag = DisposeBag()
  
  private let _users = BehaviorRelay<[User]>(value: [])
  private let _isFetcingUsers = BehaviorRelay<Bool>(value: false)
  private let _error = BehaviorRelay<String?>(value: nil)
  
  var users: Driver<[User]> {
    return _users.asDriver()
  }
  
  var isFetchingUsers: Driver<Bool> {
    return _isFetcingUsers.asDriver()
  }
  
  var error: Driver<String?> {
    return _error.asDriver()
  }
  
  var usersCount: Int {
    return _users.value.count
  }
  
  func getUsers() {
    self._error.accept(nil)
    self._isFetcingUsers.accept(true)
    let githubService = GithubService.shared
    
    githubService.getGithubUsers()
      .map{ $0.username }
      .flatMap(githubService.getGithubUser)
      .subscribe(onNext: { (user) in
        self._users.accept(self._users.value + [user])
        self._isFetcingUsers.accept(false)
      }, onError: { (error) in
        self._error.accept(error.localizedDescription)
        self._isFetcingUsers.accept(false)
      })
      .disposed(by: disposeBag)
      
//      .subscribe(onNext: { [weak self] data in
//        let jsonDecoder = JSONDecoder()
//        do {
//          let users = try jsonDecoder.decode([User].self, from: data)
//          self?._users.accept(users)
//          self?._isFetcingUsers.accept(false)
//        } catch let e {
//          print(e.localizedDescription)
//          return
//        }
//        }, onError: { [weak self] error in
//          self?._isFetcingUsers.accept(false)
//          self?._error.accept(error.localizedDescription)
//      }).disposed(by: disposeBag)
  }
  
  func getUserViewModel(at index: Int) -> UserViewModel? {
    guard index < _users.value.count else {
      return nil
    }
    
    return UserViewModel(user: _users.value[index])
  }
}
