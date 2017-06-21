//
//  RegisterVC.swift
//  Memory
//
//  Created by Георгий Мамардашвили on 20.06.17.
//  Copyright © 2017 Георгий Мамардашвили. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController
{
    var logoText: UILabel? = nil
    var typeText: UILabel? = nil
    var contentView: UIView? = nil
    var usernameTF: UITextField? = nil
    var emailTF: UITextField? = nil
    var passwordTF: UITextField? = nil
    var haveAccountBT: UIButton? = nil
    var okBT: UIButton? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setView()
        hideKeyboardWhenTappedAround()
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
}

//MARK: --actions
extension RegisterVC
{
    @objc func goToLoginVC()
    {
        self.navigationController?.pushViewController(LoginVC(), animated: true)
    }
    
    @objc func tryRegister()
    {
        if((usernameTF?.text!.isEmpty)! || (passwordTF?.text!.isEmpty)! || (emailTF?.text!.isEmpty)!)
        {
            usernameTF?.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            passwordTF?.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            emailTF?.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            return
        }
        
        let username: String = (usernameTF?.text!.lowercased())!
        let password: String = (passwordTF?.text!.lowercased())!
        let email: String = (emailTF?.text!.lowercased())!
        if(password.characters.count<6)
        {
            self.showError(text: "Password should be at least 6 charactes")
            return
        }
        //chech email?
            
        let url = URL(string:"http://localhost/gmemory/register.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "username=\(username)&password=\(password)&email=\(email)"
        request.httpBody = body.data(using: String.Encoding.utf8)
            
        URLSession.shared.dataTask(with: request, completionHandler:
        {
            (data:Data?, response: URLResponse?, error:Error?) in
            if (error != nil){
                DispatchQueue.main.async(execute:{
                    self.showError(text: "Error with network")
                })
                return
            }
            DispatchQueue.main.async(execute:
            {
                do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: String]
                        if(json!["status"]=="NO_2")
                        {
                            self.showError(text: "Error with connection to database")
                            return
                        }
                        else if(json!["status"]=="NO_3"){
                            self.showError(text: "User with such info exists")
                            return
                        }
                        else if(json!["status"]=="YES")
                        {
                            //succesfull register
                            self.navigationController?.pushViewController(ProfileVC(), animated: true)
                        }
                }
                catch {
                        self.showError(text: "Error on server")
                        return
                }
            })
        }).resume()
    }
}

//create view
extension RegisterVC
{
    func setView()
    {
        setLogoText()
        setTypeText()
        setContentView()
        setHaveAccountBT()
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
        typeText?.text = "Register"
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
        contentView?.heightAnchor.constraint(equalToConstant: 125).isActive=true
        setusernameTF()
        setEmailTF()
        setPasswordTF()
    }
    
    func setusernameTF()
    {
        usernameTF = UITextField();
        usernameTF?.placeholder = "username"
        usernameTF?.borderStyle = .roundedRect
        usernameTF?.autocapitalizationType = .none
        usernameTF?.autocorrectionType = .no
        usernameTF?.translatesAutoresizingMaskIntoConstraints = false
        view?.addSubview(usernameTF!)
        usernameTF?.rightAnchor.constraint(equalTo: (contentView?.rightAnchor)!).isActive=true
        usernameTF?.leftAnchor.constraint(equalTo: (contentView?.leftAnchor)!).isActive=true
        usernameTF?.topAnchor.constraint(equalTo: (contentView?.topAnchor)!).isActive=true
        usernameTF?.heightAnchor.constraint(equalToConstant: 35).isActive=true
    }
    
    func setEmailTF()
    {
        emailTF = UITextField();
        emailTF?.placeholder = "email"
        emailTF?.borderStyle = .roundedRect
        emailTF?.autocapitalizationType = .none
        usernameTF?.autocorrectionType = .no
        emailTF?.translatesAutoresizingMaskIntoConstraints = false
        emailTF?.keyboardType = .emailAddress
        view?.addSubview(emailTF!)
        emailTF?.rightAnchor.constraint(equalTo: (contentView?.rightAnchor)!).isActive=true
        emailTF?.leftAnchor.constraint(equalTo: (contentView?.leftAnchor)!).isActive=true
        emailTF?.topAnchor.constraint(equalTo: (usernameTF?.bottomAnchor)!, constant: 10).isActive=true
        emailTF?.heightAnchor.constraint(equalToConstant:35).isActive=true
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
        passwordTF?.topAnchor.constraint(equalTo: (emailTF?.bottomAnchor)!, constant: 10).isActive=true
        passwordTF?.heightAnchor.constraint(equalToConstant: 35).isActive=true
    }
    
    func setHaveAccountBT()
    {
        haveAccountBT = UIButton(type: .system);
        haveAccountBT?.setTitle("Have already an account?", for: .normal)
        haveAccountBT?.translatesAutoresizingMaskIntoConstraints = false
        haveAccountBT?.addTarget(self, action: #selector(goToLoginVC), for: .touchUpInside)

        view.addSubview(haveAccountBT!)
        haveAccountBT?.leftAnchor.constraint(equalTo: (view?.leftAnchor)!, constant: 15).isActive=true
        haveAccountBT?.widthAnchor.constraint(equalToConstant:180).isActive=true
        haveAccountBT?.topAnchor.constraint(equalTo: (contentView?.bottomAnchor)!, constant: 10).isActive=true
        haveAccountBT?.heightAnchor.constraint(equalToConstant:30).isActive=true
    }
    
    func setOkBT()
    {
        okBT = UIButton(type: .system);
        okBT?.setTitle("OK", for: .normal)
        okBT?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        okBT?.translatesAutoresizingMaskIntoConstraints = false
        okBT?.addTarget(self, action: #selector(tryRegister), for: .touchUpInside)
        
        view.addSubview(okBT!)
        okBT?.centerXAnchor.constraint(equalTo: (view?.centerXAnchor)!).isActive=true
        okBT?.widthAnchor.constraint(equalToConstant:50).isActive=true
        okBT?.topAnchor.constraint(equalTo: (haveAccountBT?.bottomAnchor)!, constant: 30).isActive=true
        okBT?.heightAnchor.constraint(equalToConstant:50).isActive=true
    }
}

