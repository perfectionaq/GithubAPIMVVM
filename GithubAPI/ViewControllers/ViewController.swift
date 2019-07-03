//
//  ViewController.swift
//  GithubAPI
//
//  Created by Kamal on 6/30/19.
//  Copyright © 2019 kamalqawlaq. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  var usersViewModel = UsersViewModel()
  let disposeBag = DisposeBag()
  
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var usersTableView: UITableView!
  
  func showErrorAlert(_ message: String) {
    let alertViewController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    alertViewController.addAction(alertAction)
    self.present(alertViewController, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    usersViewModel.isFetchingUsers
      .drive(loadingIndicator.rx.isAnimating)
      .disposed(by: disposeBag)
    
    usersViewModel.error.asObservable().subscribe(onNext: { (error) in
      if let error = error {
        self.showErrorAlert(error)
      }
    })
    .disposed(by: disposeBag)
    
    
    usersTableView.delegate = self
    usersTableView.dataSource = self
    usersTableView.rowHeight = 105
    usersTableView.estimatedRowHeight = 105
    
    
    usersViewModel
      .users.drive(onNext: {[unowned self] (_) in
        self.usersTableView.reloadData()
      }).disposed(by: disposeBag)
    
    usersViewModel.getUsers()
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usersViewModel.usersCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let userCell = usersTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
    if let viewModel = usersViewModel.getUserViewModel(at: indexPath.row) {
      userCell.configureView()
      userCell.configure(viewModel: viewModel)
    }
    
    return userCell
  }
}

