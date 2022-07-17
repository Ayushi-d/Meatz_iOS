//
//  MyBoxesView.swift
//  Meatz
//
//  Created by Nabil Elsherbene on 3/22/21.
//
import UIKit
final class MyBoxesView: MainView {
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var boxesTableView: UITableView!
    @IBOutlet weak var createBoxContainerView: UIView!
    
    var didLoading = false
    
    // MARK: - ViewModel

    var viewModel: MyBoxesVMProtocol!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        onError()
        onCompletion()
        setNavigationItems(true)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.messageView(hide: true)
        showLoginView()
    }

    private func showLoginView() {
        let vc = R.storyboard.boxes.loginFirstAlertController()
        vc?.coordinator = viewModel?.coordinator
        guard CachingManager.shared.isLogin else {
            addChildController(containerView, child: vc)
            return
        }
        if !didLoading{
            showLoading()
            didLoading = true
        }
        viewModel.viewDidLoad()
    }
    
    override func notificationPressed() {
        viewModel.goToNotification()
    }

    @IBAction func createNewBoxAction(_ sender: Any) {
        viewModel.navigateToCreateBox()
    }
}

// MARK: - Update UI

private extension MyBoxesView {
    func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self, let err = error else { return }
            self.hideLoading()
            self.showToast("", err.describtionError, completion: nil)
        }
    }

    func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] msg in
            guard let self = self else { return }
            self.hideLoading()
            
            let isEmpty = self.viewModel.numberOfBoxes == 0
            if isEmpty{
                self.messageView(R.string.localizable.boxesEmptyMessage(),
                                 R.image.blackBox(), hide: !isEmpty)
            }
            self.boxesTableView?.reloadData()
            
            if let msg = msg , !msg.isEmpty {
                self.showToast("", msg, completion: nil)
            }
        }
    }
    
    private func showLoading(){
     startShimmerAnimation()
        boxesTableView.startShimmerAnimation(withIdentifier: BoxesViewCell.identifier)
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        boxesTableView.stopShimmerAnimation()
    }
}

// MARK: - TabeView Adapter

extension MyBoxesView: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        boxesTableView.delegate = self
        boxesTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfBoxes
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(BoxesViewCell.self, indexPath: indexPath)
        cell.model = viewModel.dequeCellForRow(at: indexPath)
        cell.deleteButonAction = { [weak self] in
            guard let self = self else { return }
            self.showDialogue(R.string.localizable.deleteBox(), R.string.localizable.areYouSureWantToRemoveBox(), R.string.localizable.ok().uppercased()) {
                self.viewModel.deleteBox(at: indexPath)
            }
        }
        cell.addToCartButonAction = { [weak self] isActive in
            guard let self = self else { return }
            if isActive == 0  {
                self.showDialogue(R.string.localizable.itemsNotAvailable(), R.string.localizable.mayBe1Or2ItemsAreNotAvailableRightNowRestOfYourItemsHasBeenAddedYourCart(), R.string.localizable.ok().uppercased()) {}
            }
            self.showActivityIndicator()
            self.viewModel.addToCart(at: indexPath)
        }
        cell.viewItemsButtonAction = { [weak self] in
            guard let self = self else { return }
            self.viewModel.navigateToBoxDetails(with: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}
