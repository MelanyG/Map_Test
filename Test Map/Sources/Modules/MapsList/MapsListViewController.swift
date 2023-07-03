//
//  MapsListViewController.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import UIKit

extension Constants.Digits {
    static let defaultEstimatedTableCellHeight: CGFloat = 56
}

protocol MapsListViewControllable: ViewController, CountryCellDelegate {
    func setUpUI(title: String)
    func setDeviceData(progress: Float, freeSpace: String)
    func configureViews()
    func reloadCell(at indexPath: IndexPath)
}

class MapsListViewController: BaseViewController {
    @IBOutlet weak var deviceDataView: DeviceDataView?
    @IBOutlet weak var tableView: UITableView!
    private let cellIdentifier = String(describing: CountryTableViewCell.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
    }
    
    private func setTableView() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = Constants.Digits.defaultEstimatedTableCellHeight
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MapsListViewController: MapsListViewControllable {
    func setUpUI(title: String) {
        navigationBar?.title = title
    }
    
    func setDeviceData(progress: Float, freeSpace: String) {
        deviceDataView?.setUpData(progress: progress, freeSpace: freeSpace)
    }
    
    func configureViews() {
        deviceDataView?.removeFromSuperview()
    }
    
    func reloadCell(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension MapsListViewController: NavigationBarDelegate {
    func leftActionSelected(with owner: Any) {
        currentPresenter.backPressed()
    }
}

extension MapsListViewController: ViewControllerWithDefinedPresenter {
    typealias CurrentPresenter = MapsListPresentable
}

extension MapsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPresenter.item(selectedAtIndex: indexPath.row)
    }
}

extension MapsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPresenter.itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CountryTableViewCell.self)", for: indexPath)
        cell.layer.zPosition = CGFloat(indexPath.row)
        
        fill(cell: cell, atIndex: indexPath.row)
        
        return cell
    }
    
    private func fill(cell: UITableViewCell, atIndex index: Int) {
        guard let cell = cell as? PlainModelFillable else {
            return
        }
        
        currentPresenter.fill(item: cell, atIndex: index)
    }
}

extension MapsListViewController: CountryCellDelegate {
    func downloadSelected(selectedIn owner: Any) {
        guard
            let cell = owner as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell)
        else {
            return
        }
        
        currentPresenter.mapDownloadSelected(index: indexPath)
    }
}
