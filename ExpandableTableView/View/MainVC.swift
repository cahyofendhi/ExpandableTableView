//
//  ViewController.swift
//  ExpandableTableView
//
//  Created by Rumah Ulya on 07/11/18.
//  Copyright © 2018 Rumah Ulya. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    
    fileprivate let viewModel = MainVM()
    var data = [ItemBaseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        viewModel.getDataItems { response in
            self.data.append(contentsOf: response)
            self.tableView?.reloadData()
            print("Jumlah Data : \(response.count)")
        } // get data from viewmodel
    }

    func initTableView() {
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.sectionHeaderHeight = 85
        self.tableView?.register(HeaderView.nib, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        self.tableView?.register(NamePictureCell.nib, forCellReuseIdentifier: NamePictureCell.identifier)
        self.tableView?.register(AboutCell.nib, forCellReuseIdentifier: AboutCell.identifier)
        self.tableView?.register(EmailCell.nib, forCellReuseIdentifier: EmailCell.identifier)
        self.tableView?.register(AttributeCell.nib, forCellReuseIdentifier: AttributeCell.identifier)
        self.tableView?.register(FriendCell.nib, forCellReuseIdentifier: FriendCell.identifier)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MainVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = data[section]
        guard item.isCollapsible else {
            return item.rowCount
        }
        
        if item.isCollapsed {
            return 0
        } else {
            return item.rowCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.section]
        switch item.type {
        case .nameAndPicture:
            if let cell = tableView.dequeueReusableCell(withIdentifier: NamePictureCell.identifier, for: indexPath) as? NamePictureCell {
                cell.item = item
                return cell
            }
        case .about:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.identifier, for: indexPath) as? AboutCell {
                cell.item = item
                return cell
            }
        case .email:
            if let cell = tableView.dequeueReusableCell(withIdentifier: EmailCell.identifier, for: indexPath) as? EmailCell {
                cell.item = item
                return cell
            }
        case .friend:
            if let item = item as? ItemFriends, let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as? FriendCell {
                let friend = item.friends[indexPath.row]
                cell.item = friend
                return cell
            }
        case .attribute:
            if let item = item as? ItemAttribute, let cell = tableView.dequeueReusableCell(withIdentifier: AttributeCell.identifier, for: indexPath) as? AttributeCell {
                cell.item = item.attributes[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
}

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView {
            let item = data[section]
            
            headerView.item = item
            headerView.section = section
            headerView.delegate = self
            return headerView
        }
        return UIView()
    }
}

extension MainVC: HeaderViewDelegate {
    
    func toggleSection(header: HeaderView, section: Int) {
        var item = data[section]
        if item.isCollapsible {
            
            // Toggle collapse
            let collapsed = !item.isCollapsed
            item.isCollapsed = collapsed
            header.setCollapsed(collapsed: collapsed)
            
            // Adjust the number of the rows inside the section
            reloadSections(section)
        }
    }
    
    func reloadSections(_ section: Int) {
        self.tableView?.beginUpdates()
        self.tableView?.reloadSections([section], with: .fade)
        self.tableView?.endUpdates()
    }
    
    
}


