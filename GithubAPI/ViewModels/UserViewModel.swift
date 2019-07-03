//
//  UserViewModel.swift
//  GithubAPI
//
//  Created by tauta on 7/2/19.
//  Copyright © 2019 kamalqawlaq. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit

class UserViewModel {
  private var user: User
  
  private var _userAvatar = BehaviorRelay<UIImage?>(value: nil)
  private var _followersCount = BehaviorRelay<String>(value: "0")
  private var _reposCount = BehaviorRelay<String>(value: "0")
  private var disposeBag = DisposeBag()
  
  
  init(user: User) {
    self.user = user
    _followersCount.accept("\(user.numberOfFollowers!)")
    _reposCount.accept("\(user.numberOfPublicRespositories!)")
  }
  
  var username: String {
    return user.username
  }
  
  var avatarURL: String {
    return user.avatarURL
  }
  
  var userAvatar: BehaviorRelay<UIImage?> {
    return _userAvatar
  }
  
  var numberOfFollowers: Driver<String> {
    return _followersCount.asDriver()
  }
  
  var numberOfPublicRepositories: Driver<String> {
    return _reposCount.asDriver()
  }
  
  func fetchUserAvatar() {
    if let cachedImage = ImageCache.shared.getUserAvatarImageFromCache(user.avatarURL) {
      _userAvatar.accept(cachedImage)
      return
    }
    
    GithubService.shared.downloadUserImage(user.avatarURL).subscribe(onNext: { (data) in
      let image = UIImage(data: data)
      self._userAvatar.accept(image)
      ImageCache.shared.cacheUserAvatarImage(self.user.avatarURL, userAvatarImage: image!)
    }).disposed(by: disposeBag)
  }
  
}
