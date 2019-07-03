//
//  RepositoryViewModel.swift
//  GithubAPI
//
//  Created by kamalqawlaq on 03/07/2019.
//  Copyright © 2019 kamalqawlaq. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit

class RespositoryViewModel {
  private var repo: Repository
  
  private var _repoName = BehaviorRelay<String>(value: "")
  private var _repoDescription = BehaviorRelay<String?>(value: nil)
  private var disposeBag = DisposeBag()
  
  
  var repoName: Driver<String> {
    return _repoName.asDriver()
  }
  
  var repoDescription: Driver<String?> {
    return _repoDescription.asDriver()
  }
  
  init(repo: Repository) {
    self.repo = repo
    _repoName.accept(repo.name)
    _repoDescription.accept(repo.description)
  }
  
}

