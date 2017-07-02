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
    
    var type: String? = nil
    var words = [AnyObject]()
    
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
        searchBar.autocapitalizationType = .none
        self.navigationItem.titleView = searchBar
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

//action
extension FindItemVC
{
    func addWord(wordText: String?, transText: String?, posText: String?)
    {
        var myUrl: String? = nil
        if (type == "eng"){
            myUrl = "http://localhost/gmemory/addEngWord.php"
        }
        else if (type == "rus"){
            myUrl = "http://localhost/gmemory/addRusWord.php"
        }
        let alert = createAlert(wordText: wordText, transText: transText, posText: posText, myUrl: myUrl!)
        self.present(alert, animated: true, completion: nil)
    }
    
    func addTopic(title:String?)
    {
        let user:String = activeUser!["username"]!
        let alert = createTopicAlert(title: title, user: user, myUrl: "http://localhost/gmemory/addTopic.php")
        self.present(alert, animated: true, completion: nil)
    }
}

//search bar
extension FindItemVC
{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        var request: URLRequest?
        
        if(type == "eng")
        {
            request = createRequest(myUrl: "http://localhost/gmemory/getEngWords.php", searchText: searchText)
        }
        else if (type == "rus")
        {
            request = createRequest(myUrl: "http://localhost/gmemory/getRusWords.php", searchText: searchText)
        }
        else if (type == "top")
        {
            let user:String = activeUser!["username"]!
            request = createRequest(myUrl: "http://localhost/gmemory/getTopics.php", searchText: searchText, username: user)
        }
        
        URLSession.shared.dataTask(with: request!, completionHandler:
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
                            let notParseJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:AnyObject]
                            guard let json = notParseJson else{
                                print("error")
                                return
                            }
                            let status: String = json["status"]! as! String
                            if(status=="NO_3")
                            {
                                self.words.removeAll(keepingCapacity: true)
                                self.tableView.reloadData()
                                return
                            }
                            else if(status=="YES")
                            {
                                guard let tempWords = json["words"] as? [AnyObject] else{
                                    print("error")
                                    return
                                }
                                self.words = tempWords
                                self.tableView.reloadData()
                                print(self.words.count)
                            }
                        }
                        catch {
                            self.showError(text: "Error on server")
                            return
                        }
                })
        }).resume()
    }
    
    func createRequest(myUrl: String, searchText: String) -> URLRequest
    {
        let url = URL(string:myUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "text=\(searchText)"
        request.httpBody = body.data(using: String.Encoding.utf8)
        return request
    }
    
    func createRequest(myUrl: String, searchText: String, username: String) -> URLRequest
    {
        let url = URL(string:myUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "text=\(searchText)&user=\(username)"
        request.httpBody = body.data(using: String.Encoding.utf8)
        return request
    }
}

//table view
extension FindItemVC
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count+1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        if(indexPath.row==0)
        {
            if(type == "rus" || type == "eng"){
                cell.textLabel?.text = searchBar.text! + " - add new word"
            }
            else{
                cell.textLabel?.text = searchBar.text! + " - add new topic"
            }
        }
        else
        {
            let word = words[indexPath.row-1]
            let title:String = word["title"] as! String
            
            var fulltext: String?
            if(type == "rus" || type == "eng"){
                let type:String = word["speech"] as! String
                fulltext = title + " - " + type
            }
            else{
                fulltext = title
            }
            
            cell.textLabel?.text = fulltext
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row==0)
        {
            if(type == "eng" || type == "rus"){
                addWord(wordText: self.searchBar.text, transText: nil,posText: nil)
            }
            else if (type == "top"){
                addTopic(title: self.searchBar.text)
            }
        }
        else
        {
            if(type == "eng"){
                segmentVC?.engWord = words[indexPath.row-1]
            }
            else if (type == "rus"){
                segmentVC?.rusWord = words[indexPath.row-1]
            }
            else if (type == "top"){
                segmentVC?.topic = words[indexPath.row-1]
            }
            navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: tools
extension FindItemVC
{
    func idPOSByTitle(title: String) -> Int
    {
        if (title == "noun")
        {return 1}
        else if (title == "verb")
        {return 2}
        else
        {return 3}
    }
    
    func createAlert(wordText: String?, transText: String?, posText: String?, myUrl: String) -> UIAlertController
    {
        let alert = UIAlertController(title: "Adding new word", message: "This word will be added to database", preferredStyle: .alert)
        alert.addTextField(configurationHandler:{
            (textField) in
            textField.placeholder = "Word"
            textField.borderStyle = .roundedRect
            textField.text = wordText
        })
        alert.addTextField(configurationHandler:{
            (textField) in
            textField.placeholder = "Transcription"
            textField.text = transText
            textField.borderStyle = .roundedRect
        })
        alert.addTextField(configurationHandler:{
            (textField) in
            textField.text = posText
            textField.placeholder = "Part of speech"
            textField.borderStyle = .roundedRect
        })
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            [weak alert] (_) in
            if((alert?.textFields![0].text?.isEmpty)! || (alert?.textFields![1].text?.isEmpty)! || (alert?.textFields![2].text?.isEmpty)!)
            {
                self.showError(text: "Fill all of the fields")
                return
            }
            let word: String = (alert?.textFields![0].text!)!
            let trans: String = (alert?.textFields![1].text!)!
            let pos: String = (alert?.textFields![2].text!)!
            if (!(pos=="noun" || pos=="verb" || pos=="adjective"))
            {
                self.showError(text: "Wrong part of speech")
                return
            }
            let posID = self.idPOSByTitle(title: pos)
            
            let url = URL(string: myUrl)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let body = "title=\(word)&trans=\(trans)&posID=\(posID)"
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
                                    self.showError(text: "Word was not added")
                                    return
                                }
                                else if(status=="YES")
                                {
                                    //succesfull register
                                    let word: AnyObject = json!["word"]!
                                    if(self.type == "eng"){
                                        self.segmentVC?.engWord = word
                                    }
                                    else if (self.type == "rus"){
                                        self.segmentVC?.rusWord = word
                                    }
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            catch {
                                self.showError(text: "Error on server")
                                return
                            }
                    })
            }).resume()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        return alert
    }
    
    func createTopicAlert(title: String?, user:String, myUrl: String) -> UIAlertController
    {
        let alert = UIAlertController(title: "Adding new topic", message: "This topic will be added to database", preferredStyle: .alert)
        alert.addTextField(configurationHandler:{
            (textField) in
            textField.placeholder = "Title"
            textField.borderStyle = .roundedRect
            textField.text = title
        })
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            [weak alert] (_) in
            if((alert?.textFields![0].text?.isEmpty)!)
            {
                self.showError(text: "Fill all of the fields")
                return
            }
            let mytitle: String = (alert?.textFields![0].text!)!
            
            let url = URL(string: myUrl)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let body = "title=\(mytitle)&user=\(user)"
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
                                    self.showError(text: "Word was not added")
                                    return
                                }
                                else if(status=="YES")
                                {
                                    //succesfull register
                                    let topic: AnyObject = json!["topic"]!
                                    self.segmentVC?.topic = topic
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            catch {
                                self.showError(text: "Error on server")
                                return
                            }
                    })
            }).resume()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        return alert
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        if(type == "top")
        {
            var request: URLRequest?
            let user:String = activeUser!["username"]!
            request = createRequest(myUrl: "http://localhost/gmemory/getAllTopics.php", searchText: user)
            URLSession.shared.dataTask(with: request!, completionHandler:
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
                                let notParseJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:AnyObject]
                                guard let json = notParseJson else{
                                    print("error")
                                    return
                                }
                                let status: String = json["status"]! as! String
                                if(status=="NO_3")
                                {
                                    self.words.removeAll(keepingCapacity: true)
                                    self.tableView.reloadData()
                                    return
                                }
                                else if(status=="YES")
                                {
                                    guard let tempWords = json["words"] as? [AnyObject] else{
                                        print("error")
                                        return
                                    }
                                    self.words = tempWords
                                    self.tableView.reloadData()
                                    print(self.words.count)
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
}


