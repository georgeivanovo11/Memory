//
//  FindItemVC.swift
//  Memory
//
//  Created by Георгий Мамардашвили on 23.06.17.
//  Copyright © 2017 Георгий Мамардашвили. All rights reserved.
//

import UIKit

class FindItemVC: UITableViewController,  UISearchBarDelegate
{
    var name: String?
    lazy var searchBar = UISearchBar()
    var segmentVC: AddSegmentVC?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.hidesBackButton=true
        searchBar.barTintColor = UIColor.white
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = name!
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.showsCancelButton=true
        self.navigationItem.titleView = searchBar
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

//search bar
extension FindItemVC
{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        navigationController?.popViewController(animated: true)
    }
}

//table view
extension FindItemVC
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        if(indexPath.row==0)
        {
            cell1.textLabel?.text = searchBar.text! + " - add word in database"
        }
        else
        {
            cell1.textLabel?.text = "hello"
        }
        return cell1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row==0)
        {
            segmentVC?.engTF?.text = searchBar.text
            navigationController?.popViewController(animated: true)
        }
    }
}
