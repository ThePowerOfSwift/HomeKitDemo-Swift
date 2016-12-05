//
//  AccessoriesViewController.swift
//  HomeKitDemo
//
//  Created by Vlad on 11/27/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import HomeKit
import SnapKit

class AccessoriesViewController: UIViewController {
    let homeManager = HMHomeManager()
    var activeHome: HMHome?
    var activeRoom: HMRoom?
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AccessoryTableViewCell.self, forCellReuseIdentifier: AccessoryTableViewCell.reuseIdentifier)
        tableView.rowHeight = AccessoryTableViewCell.defaultHeight
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        homeManager.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension AccessoriesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let accessories = activeRoom?.accessories {
            return accessories.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccessoryTableViewCell.reuseIdentifier, for: indexPath) as! AccessoryTableViewCell
        let accessory = activeRoom!.accessories[indexPath.row] as HMAccessory
        let servicesNumber = "\(accessory.services.count - 1) service(s)"
        let state = accessory.isReachable ? "Online" : "Offline"
        cell.set(name: accessory.name, info: servicesNumber, state: state)
        return cell
    }
}

extension AccessoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let room = activeRoom {
            let accessory = room.accessories[indexPath.row]
            let vc = AccessoryViewController.storyboardInstance(withTitle: accessory.name) as! AccessoryViewController
            vc.accessory = accessory
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: Actions
extension AccessoriesViewController {
    @objc fileprivate func addPressed() {
        let vc = DiscoveryViewController.storyboardInstance(withTitle: "Searching...")
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Setup
extension AccessoriesViewController {
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    fileprivate func initialSetup() {
        homeManager.addHome(withName: "Generator HUB") { home, error in
            guard error == nil else { return print("Couldn't create home. Error: \(error?.localizedDescription)") }
            if let discoveredHome = home {
                self.addRoom(to: discoveredHome)
                self.updatePrimaryHome(with: discoveredHome)
            } else {
                print("Something went wrong when attemting to create home.")
            }
        }
    }
}

// MARK: Helpers
extension AccessoriesViewController {
    fileprivate func updateController(with home: HMHome) {
        guard let room = home.rooms.first as HMRoom? else { return }
        activeRoom = room
        title = "\(room.name) @ \(home.name)"
    }

    fileprivate func addRoom(to home: HMHome) {
        home.addRoom(withName: "Presentation Room") { room, error in
            guard error == nil else { return print("Couldn't create room. Error: \(error?.localizedDescription)") }
            self.updateController(with: home)
        }
    }

    fileprivate func updatePrimaryHome(with home: HMHome) {
        homeManager.updatePrimaryHome(home) { error in
            guard error == nil else { return print("Couldn't update primary home. Error: \(error?.localizedDescription)") }
        }
    }
}

extension AccessoriesViewController: HMHomeManagerDelegate {
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        if let home = manager.primaryHome {
            activeHome = home
            updateController(with: home)
        } else {
            initialSetup()
        }
        tableView.reloadData()
    }
}

// MARK: Layout
extension AccessoriesViewController: Layoutable {
    func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
}

