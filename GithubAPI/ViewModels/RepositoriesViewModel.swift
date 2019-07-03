//
//  RepositoriesViewModel.swift
//  GithubAPI
//
//  Created by kamalqawlaq on 03/07/2019.
//  Copyright © 2019 kamalqawlaq. All rights reserved.
//

import RxSwift
import RxCocoa
import RxRelay

class RepositoriesViewModel {
  
  private var repositoryOwnerUsername: String
  
  private let disposeBag = DisposeBag()
  
  private let _repos = BehaviorRelay<[Repository]>(value: [])
  private let _isFetchingRepos = BehaviorRelay<Bool>(value: false)
  private let _error = BehaviorRelay<String?>(value: nil)
  
  
  init(ownerUsername: String) {
    self.repositoryOwnerUsername = ownerUsername
  }
  
  var repos: Driver<[Repository]> {
    return _repos.asDriver()
  }
  
  var isFetchingRepos: Driver<Bool> {
    return _isFetchingRepos.asDriver()
  }
  
  var error: Driver<String?> {
    return _error.asDriver()
  }
  
  var reposCount: Int {
    return _repos.value.count
  }
  
  func getRepos() {
    self._error.accept(nil)
    self._isFetchingRepos.accept(true)
    let githubService = GithubService.shared
    
    githubService.getReposOfUser(repositoryOwnerUsername)
      .subscribe(onNext: { (repos) in
        self._repos.accept(repos)
        self._isFetchingRepos.accept(false)
      }, onError: { (error) in
        self._error.accept(error.localizedDescription)
        self._isFetchingRepos.accept(false)
      })
      .disposed(by: disposeBag)
  }
  
  func getRepoViewModel(at index: Int) -> RespositoryViewModel? {
    guard index < _repos.value.count else {
      return nil
    }
    
    return RespositoryViewModel(repo: _repos.value[index])
  }
}

