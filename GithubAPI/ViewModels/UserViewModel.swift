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
  private var disposeBag = DisposeBag()
  
  
  init(user: User) {
    self.user = user
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
  
  func fetchUserAvatar() {
    if let cachedImage = ImageCache.shared.getUserAvatarImageFromCache(user.avatarURL) {
      print("cached")
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