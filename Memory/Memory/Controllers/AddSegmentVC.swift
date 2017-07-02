//
//  AddSegmentVC.swift
//  Memory
//
//  Created by Георгий Мамардашвили on 23.06.17.
//  Copyright © 2017 Георгий Мамардашвили. All rights reserved.
//

import UIKit

class AddSegmentVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var engLB: UILabel?
    var engTF: UITextField?
    var rusLB: UILabel?
    var rusTF: UITextField?
    var topicLB: UILabel?
    var topicTF: UITextField?
    var aboutLB: UILabel?
    var aboutTF: UITextField?
    var exampleLB: UILabel?
    var exampleTV = UITableView()
    
    var engWord:AnyObject?
    var rusWord:AnyObject?
    var topic: AnyObject?
    var about: String?
    var examples = [AnyObject]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Segment"
        view.backgroundColor = UIColor.white
        hideKeyboardWhenTappedAround()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        self.exampleTV.delegate = self
        self.exampleTV.dataSource = self
        self.exampleTV.allowsSelection = true
        self.exampleTV.register(UITableViewCell.self, forCellReuseIdentifier: "addCell")
        
        setView()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if (engWord != nil)
        {
            let engWordText = engWord!["title"] as! String
            engTF?.text = engWordText
        }
        if (rusWord != nil)
        {
            let rusWordText = rusWord!["title"] as! String
            rusTF?.text = rusWordText
        }
        if (topic != nil)
        {
            let topicText = topic!["title"] as! String
            topicTF?.text = topicText
        }
        exampleTV.reloadData()
    }
}

// action
extension AddSegmentVC
{
    @objc func save()
    {
        about = aboutTF?.text
        if((engWord == nil) || (rusWord == nil) || (topic == nil) || (about?.characters.count == 0))
        {
            self.showError(text: "Fill all of the fields")
            return
        }
        let engID: String = engWord!["id"] as! String
        let rusID: String = rusWord!["id"] as! String
        let aboutText:String = about!
        let topicID: String = topic!["id"] as! String
        
        saveSegment(engID: engID, rusID: rusID, aboutText: aboutText, topicID: topicID)
    }
    
    func saveSegment(engID: String, rusID: String, aboutText: String, topicID: String)
    {
        let user:String = activeUser!["username"]!
        let url = URL(string: "http://localhost/gmemory/addSegment.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "eng=\(engID)&rus=\(rusID)&user=\(user)&about=\(aboutText)"
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
                            let status:String=json!["status"]! as! String
                            if(status=="NO_2")
                            {
                                self.showError(text: "Error with connection to database")
                                return
                            }
                            else if(status=="NO_3"){
                                self.showError(text: "Segment was not added")
                                return
                            }
                            else if(status=="YES")
                            {
                                //succesfull register
                                let segment: AnyObject = json!["segment"]!
                                let segmentID: String = segment["id"] as! String
                                self.saveSegmentTopic(segmentID: segmentID, topicID: topicID)
                                self.saveSegmentExamples(segmentID: segmentID)
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
    
    func saveSegmentTopic(segmentID: String,topicID: String)
    {
        let url = URL(string: "http://localhost/gmemory/addSegmentTopic.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "segment=\(segmentID)&topic=\(topicID)"
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
                            let status:String=json!["status"]! as! String
                            if(status=="NO_2")
                            {
                                self.showError(text: "Error with connection to database")
                                return
                            }
                            else if(status=="NO_3"){
                                self.showError(text: "Segment was not added")
                                return
                            }
                            else if(status=="YES")
                            {
                                //succesfull register
                                print("yes")
                                //self.navigationController?.popViewController(animated: true)
                            }
                        }
                        catch {
                            self.showError(text: "Error on server")
                            return
                        }
                })
        }).resume()
    }
    
    func saveSegmentExamples(segmentID:String)
    {
        for example in self.examples
        {
            let exampleID: String = example["id"] as! String
            let url = URL(string: "http://localhost/gmemory/addSegmentExample.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let body = "segment=\(segmentID)&example=\(exampleID)"
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
                                let status:String=json!["status"]! as! String
                                if(status=="NO_2")
                                {
                                    self.showError(text: "Error with connection to database")
                                    return
                                }
                                else if(status=="NO_3"){
                                    self.showError(text: "Example was not added")
                                    return
                                }
                                else if(status=="YES")
                                {
                                    //succesfull register
                                    print("yes")
                                    //self.navigationController?.popViewController(animated: true)
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
    
    @objc func engSearch()
    {
        let VC = FindItemVC()
        VC.type = "eng"
        VC.name = "Enter english word"
        VC.segmentVC = self
        self.navigationController?.pushViewController(VC, animated: true)
        engTF?.endEditing(true)
    }
    
    @objc func rusSearch()
    {
        let VC = FindItemVC()
        VC.type = "rus"
        VC.name = "Enter russian word"
        VC.segmentVC = self
        self.navigationController?.pushViewController(VC, animated: true)
        rusTF?.endEditing(true)
    }
    
    @objc func topicSearch()
    {
        let VC = FindItemVC()
        VC.type = "top"
        VC.name = "Enter topic"
        VC.segmentVC = self
        self.navigationController?.pushViewController(VC, animated: true)
        topicTF?.endEditing(true)
    }
    
    func addExample()
    {
        let VC = ExampleVC()
        VC.segmentVC = self
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

//table
extension AddSegmentVC
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return examples.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = exampleTV.dequeueReusableCell(withIdentifier: "addCell", for: indexPath)
        if(indexPath.row == examples.count){
            cell.textLabel?.text = "Add example"
            cell.textLabel?.textColor = UIColor.blue
        }
        else{
            
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.text = examples[indexPath.row]["engText"] as! String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row == examples.count ){
            addExample()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if(indexPath.row != examples.count)
        {
            if editingStyle == .delete {
                examples.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
    }
}

//set view
extension AddSegmentVC
{
    func setView()
    {
        engLB = UILabel()
        engLB?.text = "Eng:"
        engLB?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(engLB!)
        engLB?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive=true
        engLB?.widthAnchor.constraint(equalToConstant: 40).isActive=true
        engLB?.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive=true
        engLB?.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        engTF = UITextField()
        engTF?.borderStyle = .roundedRect
        engTF?.addTarget(self, action: #selector(engSearch), for: .editingDidBegin)
        view.addSubview(engTF!)
        engTF?.translatesAutoresizingMaskIntoConstraints = false
        engTF?.leftAnchor.constraint(equalTo: (engLB?.rightAnchor)!, constant: 5).isActive=true
        engTF?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive=true
        engTF?.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive=true
        engTF?.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        rusLB = UILabel()
        rusLB?.text = "Rus:"
        rusLB?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rusLB!)
        rusLB?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive=true
        rusLB?.widthAnchor.constraint(equalToConstant: 40).isActive=true
        rusLB?.topAnchor.constraint(equalTo: (engLB?.bottomAnchor)!, constant: 15).isActive=true
        rusLB?.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        rusTF = UITextField()
        rusTF?.borderStyle = .roundedRect
        rusTF?.addTarget(self, action: #selector(rusSearch), for: .editingDidBegin)
        view.addSubview(rusTF!)
        rusTF?.translatesAutoresizingMaskIntoConstraints = false
        rusTF?.leftAnchor.constraint(equalTo: (rusLB?.rightAnchor)!, constant: 5).isActive=true
        rusTF?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive=true
        rusTF?.topAnchor.constraint(equalTo: (engTF?.bottomAnchor)!, constant: 15).isActive=true
        rusTF?.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        topicLB = UILabel()
        topicLB?.text = "Topic:"
        topicLB?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topicLB!)
        topicLB?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive=true
        topicLB?.widthAnchor.constraint(equalToConstant: 50).isActive=true
        topicLB?.topAnchor.constraint(equalTo: (rusLB?.bottomAnchor)!, constant: 15).isActive=true
        topicLB?.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        topicTF = UITextField()
        topicTF?.borderStyle = .roundedRect
        topicTF?.addTarget(self, action: #selector(topicSearch), for: .editingDidBegin)
        view.addSubview(topicTF!)
        topicTF?.translatesAutoresizingMaskIntoConstraints = false
        topicTF?.leftAnchor.constraint(equalTo: (topicLB?.rightAnchor)!, constant: 5).isActive=true
        topicTF?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive=true
        topicTF?.topAnchor.constraint(equalTo: (rusTF?.bottomAnchor)!, constant: 15).isActive=true
        topicTF?.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        aboutLB = UILabel()
        aboutLB?.text = "About:"
        aboutLB?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(aboutLB!)
        aboutLB?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive=true
        aboutLB?.widthAnchor.constraint(equalToConstant: 60).isActive=true
        aboutLB?.topAnchor.constraint(equalTo: (topicLB?.bottomAnchor)!, constant: 15).isActive=true
        aboutLB?.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        aboutTF = UITextField()
        aboutTF?.borderStyle = .roundedRect
        view.addSubview(aboutTF!)
        aboutTF?.translatesAutoresizingMaskIntoConstraints = false
        aboutTF?.leftAnchor.constraint(equalTo: (aboutLB?.rightAnchor)!, constant: 5).isActive=true
        aboutTF?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive=true
        aboutTF?.topAnchor.constraint(equalTo: (topicTF?.bottomAnchor)!, constant: 15).isActive=true
        aboutTF?.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        exampleLB = UILabel()
        exampleLB?.text = "Examples:"
        exampleLB?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exampleLB!)
        exampleLB?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive=true
        exampleLB?.widthAnchor.constraint(equalToConstant: 80).isActive=true
        exampleLB?.topAnchor.constraint(equalTo: (aboutLB?.bottomAnchor)!, constant: 15).isActive=true
        exampleLB?.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        exampleTV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exampleTV)
        exampleTV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive=true
        exampleTV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive=true
        exampleTV.topAnchor.constraint(equalTo: (exampleLB?.bottomAnchor)!, constant: 5).isActive=true
        exampleTV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive=true
    }
}









