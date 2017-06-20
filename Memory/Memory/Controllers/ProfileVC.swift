//
//  ProfileVC.swift
//  Memory
//
//  Created by Георгий Мамардашвили on 20.06.17.
//  Copyright © 2017 Георгий Мамардашвили. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Profile"
        view.backgroundColor = UIColor.white
    }
}
