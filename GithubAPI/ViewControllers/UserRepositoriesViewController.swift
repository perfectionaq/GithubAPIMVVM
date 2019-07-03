//
//  UserRepositoriesViewController.swift
//  GithubAPI
//
//  Created by kamalqawlaq on 03/07/2019.
//  Copyright © 2019 kamalqawlaq. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserRepositoriesViewController: UIViewController {
  
  var userViewModel: UserViewModel!
  
  var disposeBag = DisposeBag()
  
  @IBOutlet weak var userAvatarImageView: UIImageView!
  
  @IBOutlet weak var userPublicReposCount: UILabel!
  
  @IBOutlet weak var userFollowersCountLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.userAvatarImageView.layer.masksToBounds = true
    self.userAvatarImageView.layer.cornerRadius = self.userAvatarImageView.frame.height / 2
    self.userAvatarImageView.clipsToBounds = true
    
    userViewModel.numberOfFollowers.drive(userFollowersCountLabel.rx.text).disposed(by: disposeBag)
    userViewModel.numberOfPublicRepositories.drive(userPublicReposCount.rx.text).disposed(by: disposeBag)
    userViewModel.userAvatar.observeOn(MainScheduler.instance).bind(to: self.userAvatarImageView.rx.image).disposed(by: disposeBag)
    userViewModel.fetchUserAvatar()
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationViewController = segue.destination as? UserRepositoriesListViewController {
      destinationViewController.respositoriesViewModel = RepositoriesViewModel(ownerUsername: userViewModel.username)
    }
  }
}
