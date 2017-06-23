//
//  SearchVC.swift
//  Memory
//
//  Created by Георгий Мамардашвили on 23.06.17.
//  Copyright © 2017 Георгий Мамардашвили. All rights reserved.
//

import UIKit

class SearchVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addSegment))
    }
}

//MARK: actions
extension SearchVC
{
    @objc func addSegment()
    {
        self.navigationController?.pushViewController(AddSegmentVC(), animated: true)
    }
}
