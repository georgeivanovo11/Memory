//
//  LoginVC.swift
//  Memory
//
//  Created by Георгий Мамардашвили on 20.06.17.
//  Copyright © 2017 Георгий Мамардашвили. All rights reserved.
//

import UIKit

class LoginVC: UIViewController
{
    var logoText: UILabel? = nil
    var typeText: UILabel? = nil
    var contentView: UIView? = nil
    var usernameTF: UITextField? = nil
    var passwordTF: UITextField? = nil
    lazy var notHaveAccountBT: UIButton? = nil
    var okBT: UIButton? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.white
        setView()
        hideKeyboardWhenTappedAround()
    }
}

//MARK:-- actions
extension LoginVC
{
    @objc func goToRegisterVC()
    {
        self.navigationController?.pushViewController(RegisterVC(), animated: true)
    }
    
    @objc func tryLogin()
    {
        //...
        self.navigationController?.pushViewController(ProfileVC(), animated: true)
    }
}

//MARK:-- create view
extension LoginVC
{
    func setView()
    {
        setLogoText()
        setTypeText()
        setContentView()
        setNotHaveAccountBT()
        setOkBT()
    }
    
    func setLogoText()
    {
        logoText = UILabel();
        logoText?.text = "Memory"
        logoText?.font = UIFont.systemFont(ofSize: 50)
        logoText?.textAlignment = .center
        logoText?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoText!)
        logoText?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        logoText?.widthAnchor.constraint(equalToConstant: 300).isActive=true
        logoText?.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive=true
        logoText?.heightAnchor.constraint(equalToConstant: 55).isActive=true
    }
    
    func setTypeText()
    {
        typeText = UILabel();
        typeText?.text = "Login"
        typeText?.font = UIFont.systemFont(ofSize: 20)
        typeText?.textAlignment = .center
        typeText?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(typeText!)
        typeText?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        typeText?.widthAnchor.constraint(equalToConstant: 300).isActive=true
        typeText?.topAnchor.constraint(equalTo: (logoText?.bottomAnchor)!, constant: 5).isActive=true
        typeText?.heightAnchor.constraint(equalToConstant: 50).isActive=true
    }
    
    func setContentView()
    {
        contentView = UILabel();
        //contentView?.backgroundColor=UIColor.blue
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView!)
        contentView?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive=true
        contentView?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive=true
        contentView?.topAnchor.constraint(equalTo: (typeText?.bottomAnchor)!, constant: 10).isActive=true
        contentView?.heightAnchor.constraint(equalToConstant: 80).isActive=true
        setUsernameTF()
        setPasswordTF()
    }
    
    func setUsernameTF()
    {
        usernameTF = UITextField();
        usernameTF?.placeholder = "username"
        usernameTF?.borderStyle = .roundedRect
        usernameTF?.autocapitalizationType = .none
        usernameTF?.translatesAutoresizingMaskIntoConstraints = false
        view?.addSubview(usernameTF!)
        usernameTF?.rightAnchor.constraint(equalTo: (contentView?.rightAnchor)!).isActive=true
        usernameTF?.leftAnchor.constraint(equalTo: (contentView?.leftAnchor)!).isActive=true
        usernameTF?.topAnchor.constraint(equalTo: (contentView?.topAnchor)!).isActive=true
        usernameTF?.heightAnchor.constraint(equalToConstant: 35).isActive=true
    }
    
    func setPasswordTF()
    {
        passwordTF = UITextField();
        passwordTF?.placeholder = "password"
        passwordTF?.borderStyle = .roundedRect
        passwordTF?.isSecureTextEntry = true
        passwordTF?.translatesAutoresizingMaskIntoConstraints = false
        view?.addSubview(passwordTF!)
        passwordTF?.rightAnchor.constraint(equalTo: (contentView?.rightAnchor)!).isActive=true
        passwordTF?.leftAnchor.constraint(equalTo: (contentView?.leftAnchor)!).isActive=true
        passwordTF?.topAnchor.constraint(equalTo: (usernameTF?.bottomAnchor)!, constant: 10).isActive=true
        passwordTF?.heightAnchor.constraint(equalToConstant: 35).isActive=true
    }
    
    func setNotHaveAccountBT()
    {
        notHaveAccountBT = UIButton(type: .system);
        notHaveAccountBT?.setTitle("Don't have an account?", for: .normal)
        notHaveAccountBT?.translatesAutoresizingMaskIntoConstraints = false
        notHaveAccountBT?.addTarget(self, action: #selector(goToRegisterVC), for: .touchUpInside)
    
        view.addSubview(notHaveAccountBT!)
        notHaveAccountBT?.leftAnchor.constraint(equalTo: (view?.leftAnchor)!, constant: 15).isActive=true
        notHaveAccountBT?.widthAnchor.constraint(equalToConstant:165).isActive=true
        notHaveAccountBT?.topAnchor.constraint(equalTo: (contentView?.bottomAnchor)!, constant: 10).isActive=true
        notHaveAccountBT?.heightAnchor.constraint(equalToConstant:30).isActive=true
    }
    
    func setOkBT()
    {
        okBT = UIButton(type: .system);
        okBT?.setTitle("OK", for: .normal)
        okBT?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        okBT?.translatesAutoresizingMaskIntoConstraints = false
        okBT?.addTarget(self, action: #selector(tryLogin), for: .touchUpInside)
        view.addSubview(okBT!)
        okBT?.centerXAnchor.constraint(equalTo: (view?.centerXAnchor)!).isActive=true
        okBT?.widthAnchor.constraint(equalToConstant:50).isActive=true
        okBT?.topAnchor.constraint(equalTo: (notHaveAccountBT?.bottomAnchor)!, constant: 30).isActive=true
        okBT?.heightAnchor.constraint(equalToConstant:50).isActive=true
    }
}
