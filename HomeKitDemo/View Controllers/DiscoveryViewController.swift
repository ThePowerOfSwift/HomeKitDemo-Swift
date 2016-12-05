//
//  DiscoveryViewController.swift
//  HomeKitDemo
//
//  Created by Vlad on 11/27/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import HomeKit
import SnapKit

class DiscoveryViewController: UIViewController {
    let homeManager = HMHomeManager()
    let browser = HMAccessoryBrowser()
    var accessories = [HMAccessory]()
    let tableView = UITableView()
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBrowser()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(startSearching))
        layout()
    }
}

extension DiscoveryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "DescriptionCell")
        let accessory = accessories[indexPath.row] as HMAccessory
        cell.textLabel?.text = accessory.name
        return cell
    }
}

extension DiscoveryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let home = homeManager.primaryHome else { return }
        if let room = home.rooms.first as HMRoom? {
            let accessory = accessories[indexPath.row] as HMAccessory
            home.addAccessory(accessory) { error in
                guard error == nil else { return print("Couldn't add accessory to home. Error: \(error?.localizedDescription)") }
                home.assignAccessory(accessory, to: room) { error in
                    guard error == nil else { return print("Couldn't add accessory to home. Error: \(error?.localizedDescription)") }
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

// MARK: Actions
extension DiscoveryViewController {
    @objc fileprivate func startSearching() {
        if let timer = timer {
            timer.invalidate()
        }
        browser.stopSearchingForNewAccessories()
        title = "Searching..."
        browser.startSearchingForNewAccessories()
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(stopSearching), userInfo: nil, repeats: false)
    }

    @objc fileprivate func stopSearching() {
        title = "\(accessories.count) device(s) found"
        browser.stopSearchingForNewAccessories()
    }
}

// MARK: Setup
extension DiscoveryViewController {
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    fileprivate func setupBrowser() {
        browser.delegate = self
        startSearching()
    }
}

// MARK: HMAccessoryBrowserDelegate
extension DiscoveryViewController: HMAccessoryBrowserDelegate {
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        accessories.append(accessory)
        tableView.reloadData()
    }

    func accessoryBrowser(_ browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
        accessories.remove(object: accessory)
        tableView.reloadData()
    }
}

//MARK: Layout
extension DiscoveryViewController: Layoutable {
    func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
}
