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
    var contentView: UIView?
    var profileImage: UIImageView?
    var usernameLB: UILabel?
    var countLB: UILabel?
    var emailLB: UILabel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Profile"
        view.backgroundColor = UIColor.white
        setView()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        usernameLB?.text = activeUser!["username"]?.uppercased()
        emailLB?.text = activeUser!["email"]
    }
}

extension ProfileVC
{
    @objc func logout()
    {
        UserDefaults.standard.removeObject(forKey: "savedUser")
        UserDefaults.standard.synchronize()
        
        self.navigationController?.pushViewController(LoginVC(), animated: true)
    }
}

//set view
extension ProfileVC
{
    func setView()
    {
        setContentView()
    }
    
    func setContentView()
    {
        contentView = UIView();
        //contentView?.backgroundColor=UIColor.blue
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView!)
        contentView?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive=true
        contentView?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive=true
        contentView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 85).isActive=true
        contentView?.heightAnchor.constraint(equalToConstant: 120).isActive=true
        setImage()
        setUsernameLB()
        setEmailLB()
        setCountLB()
    }
    
    func setImage()
    {
        profileImage = UIImageView()
        profileImage?.image = UIImage(named: "noUser")
        profileImage?.layer.cornerRadius = 20
        profileImage?.layer.masksToBounds = true
        profileImage?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.addSubview(profileImage!)
        profileImage?.leftAnchor.constraint(equalTo: (contentView?.leftAnchor)!).isActive=true
        profileImage?.topAnchor.constraint(equalTo: (contentView?.topAnchor)!).isActive=true
        profileImage?.widthAnchor.constraint(equalTo: (contentView?.widthAnchor)!, multiplier: 2/5) .isActive=true
        profileImage?.heightAnchor.constraint(equalTo: (profileImage?.widthAnchor)!).isActive=true
    }
    
    func setUsernameLB()
    {
        usernameLB = UILabel()
        usernameLB?.font = UIFont.systemFont(ofSize: 30)
        usernameLB?.text = "Username"
        usernameLB?.textAlignment = . center
        //usernameLB?.backgroundColor = UIColor.red
        usernameLB?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.addSubview(usernameLB!)
        usernameLB?.leftAnchor.constraint(equalTo: (profileImage?.rightAnchor)!).isActive=true
        usernameLB?.topAnchor.constraint(equalTo: (contentView?.topAnchor)!).isActive=true
        usernameLB?.rightAnchor.constraint(equalTo: (contentView?.rightAnchor)!) .isActive=true
        usernameLB?.heightAnchor.constraint(equalTo: (profileImage?.heightAnchor)!, multiplier: 1/3).isActive=true
    }
    
    func setCountLB()
    {
        countLB = UILabel()
        countLB?.text = "100 words"
        countLB?.textAlignment = .center
        countLB?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.addSubview(countLB!)
        countLB?.leftAnchor.constraint(equalTo: (profileImage?.rightAnchor)!).isActive=true
        countLB?.topAnchor.constraint(equalTo: (emailLB?.bottomAnchor)!).isActive=true
        countLB?.rightAnchor.constraint(equalTo: (contentView?.rightAnchor)!) .isActive=true
        countLB?.heightAnchor.constraint(equalTo: (profileImage?.heightAnchor)!, multiplier: 1/4).isActive=true
    }
    
    func setEmailLB()
    {
        emailLB = UILabel()
        emailLB?.text = "user@mail.ru"
        emailLB?.textAlignment = .center
        //emailLB?.backgroundColor = UIColor.green
        emailLB?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.addSubview(emailLB!)
        emailLB?.leftAnchor.constraint(equalTo: (profileImage?.rightAnchor)!, constant: 10).isActive=true
        emailLB?.topAnchor.constraint(equalTo: (usernameLB?.bottomAnchor)!).isActive=true
        emailLB?.rightAnchor.constraint(equalTo: (contentView?.rightAnchor)!) .isActive=true
        emailLB?.heightAnchor.constraint(equalTo: (profileImage?.heightAnchor)!, multiplier: 1/3).isActive=true
    }
    
}




















