//
//  UserTableViewCell.swift
//  GithubAPI
//
//  Created by tauta on 7/2/19.
//  Copyright © 2019 kamalqawlaq. All rights reserved.
//

import UIKit
import RxSwift

class UserTableViewCell: UITableViewCell {
  
  var disposeBag = DisposeBag()
  
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var userAvatarImageView: UIImageView!
  @IBOutlet weak var followersCountLabel: UILabel!
  @IBOutlet weak var reposCountLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

  func configureView() {
    self.userAvatarImageView.layer.masksToBounds = true
    self.userAvatarImageView.layer.cornerRadius = self.userAvatarImageView.frame.height / 2
    self.userAvatarImageView.clipsToBounds = true
    
    self.userAvatarImageView.image = UIImage(named: "github")
  }
  
  func configure(viewModel: UserViewModel) {
    self.usernameLabel.text = viewModel.username
    viewModel.numberOfFollowers.drive(followersCountLabel.rx.text).disposed(by: disposeBag)
    viewModel.numberOfPublicRepositories.drive(reposCountLabel.rx.text).disposed(by: disposeBag)
    viewModel.userAvatar.observeOn(MainScheduler.instance).bind(to: self.userAvatarImageView.rx.image).disposed(by: disposeBag)
    viewModel.fetchUserAvatar()
  }
}
