//
//  ExampleVC.swift
//  Memory
//
//  Created by Георгий Мамардашвили on 30.06.17.
//  Copyright © 2017 Георгий Мамардашвили. All rights reserved.
//

import UIKit

class ExampleVC: UIViewController
{
    var expEngTV: UITextView?
    var expRusTV: UITextView?
    
    var segmentVC: AddSegmentVC?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        navigationItem.hidesBackButton=true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveExample))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Example"
        view.backgroundColor = UIColor.white
        setView()
    }
}

//action
extension ExampleVC
{
    @objc func saveExample()
    {
        if((expRusTV?.text!.isEmpty)! || (expEngTV?.text!.isEmpty)!)
        {
            showError(text: "empty fields")
            return
        }
        
        let engtext: String = (expEngTV?.text?.lowercased())!
        let rustext: String = (expRusTV?.text?.lowercased())!
        
        let url = URL(string:"http://localhost/gmemory/addExample.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "rus=\(rustext)&eng=\(engtext)&user=george"
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
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:AnyObject]
                            let status: String = json!["status"]! as! String
                            if(status=="NO_2")
                            {
                                self.showError(text: "Error with connection to database")
                                return
                            }
                            else if(status=="NO_3" || status=="NO_4"){
                                self.showError(text: "Wrong username or password")
                                return
                            }
                            else if(status=="YES")
                            {
                                ////successful
                                let example: AnyObject = json!["example"]!
                                self.segmentVC?.examples.append(example as AnyObject)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        catch {
                            self.showError(text: "Error on server")
                            return
                        }
                })
        }).resume()
    }
    
    @objc func cancel()
    {
        navigationController?.popViewController(animated: true)
    }
}

//view
extension ExampleVC
{
    func setView()
    {
        expEngTV = UITextView()
        expEngTV?.text = "Eng"
        expEngTV?.font = UIFont.systemFont(ofSize: 20)
        expEngTV?.layer.borderColor = UIColor.lightGray.cgColor
        expEngTV?.layer.borderWidth = 1.0
        expEngTV?.layer.cornerRadius = 5.0
        expEngTV?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(expEngTV!)
        expEngTV?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive=true
        expEngTV?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive=true
        expEngTV?.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive=true
        expEngTV?.heightAnchor.constraint(equalToConstant: 100).isActive=true
        
        expRusTV = UITextView()
        expRusTV?.text = "Rus"
        expRusTV?.font = UIFont.systemFont(ofSize: 20)
        expRusTV?.layer.borderColor = UIColor.lightGray.cgColor
        expRusTV?.layer.borderWidth = 1.0
        expRusTV?.layer.cornerRadius = 5.0
        expRusTV?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(expRusTV!)
        expRusTV?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive=true
        expRusTV?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive=true
        expRusTV?.topAnchor.constraint(equalTo: (expEngTV?.bottomAnchor)!, constant: 15).isActive=true
        expRusTV?.heightAnchor.constraint(equalToConstant: 100).isActive=true
        
    }
}
