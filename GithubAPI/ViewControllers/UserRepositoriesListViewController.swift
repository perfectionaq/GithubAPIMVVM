//
//  UserRepositoriesListViewController.swift
//  GithubAPI
//
//  Created by kamalqawlaq on 03/07/2019.
//  Copyright © 2019 kamalqawlaq. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserRepositoriesListViewController: UIViewController {

  var respositoriesViewModel: RepositoriesViewModel!
  
  let disposeBag = DisposeBag()
  
  @IBOutlet weak var reposListTableView: UITableView!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    respositoriesViewModel.isFetchingRepos
      .drive(activityIndicator.rx.isAnimating)
      .disposed(by: disposeBag)
    
    
    reposListTableView.delegate = self
    reposListTableView.dataSource = self
    
    
    respositoriesViewModel
      .repos.drive(onNext: {[unowned self] (_) in
        self.reposListTableView.reloadData()
      }).disposed(by: disposeBag)
    
    respositoriesViewModel.getRepos()
  }
  
  
}


extension UserRepositoriesListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return respositoriesViewModel.reposCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let repoCell = reposListTableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
    
    if let viewModel = respositoriesViewModel.getRepoViewModel(at: indexPath.row) {
      viewModel.repoName.drive((repoCell.textLabel?.rx.text)!).disposed(by: disposeBag)
//      viewModel.repoDescription.drive((repoCell.detailTextLabel?.rx.text)!).disposed(by: disposeBag)
    }
    
    return repoCell
  }
}
