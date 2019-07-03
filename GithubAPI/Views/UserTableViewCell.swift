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
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

  func configure(viewModel: UserViewModel) {
    self.usernameLabel.text = viewModel.username
    
    viewModel.userAvatar.observeOn(MainScheduler.instance).bind(to: self.userAvatarImageView.rx.image).disposed(by: disposeBag)
    viewModel.fetchUserAvatar()
  }
}
