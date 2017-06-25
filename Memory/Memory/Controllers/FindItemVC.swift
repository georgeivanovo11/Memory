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
    func addWord()
    {
        let alert = UIAlertController(title: "Adding new word", message: "This word will be added to database", preferredStyle: .alert)
        alert.addTextField(configurationHandler:{
            (textField) in
            textField.placeholder = "Word"
            textField.borderStyle = .roundedRect
            textField.text = self.searchBar.text
        })
        alert.addTextField(configurationHandler:{
            (textField) in
            textField.placeholder = "Transcription"
            textField.borderStyle = .roundedRect
        })
        alert.addTextField(configurationHandler:{
            (textField) in
            textField.placeholder = "Part of speech"
            textField.borderStyle = .roundedRect
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            [weak alert] (_) in
            //action
            print((alert?.textFields![0].text)!)
            print((alert?.textFields![1].text)!)
            DispatchQueue.main.async(execute:
                {self.navigationController?.popViewController(animated: true)})
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
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
        let url = URL(string:"http://localhost/gmemory/getEngWord.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "text=\(searchText)"
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

//table view
extension FindItemVC
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return words.count+1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        if(indexPath.row==0)
        {
            cell1.textLabel?.text = searchBar.text! + " - add new word"
        }
        else
        {
            let word = words[indexPath.row-1]
            let title:String = word["title"] as! String
            let type:String = word["speech"] as! String
            cell1.textLabel?.text = title + " - " + type
        }
        return cell1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row==0)
        {
            addWord()
        }
        else
        {
            segmentVC?.engWord = words[indexPath.row-1]
            navigationController?.popViewController(animated: true)
        }
    }
}
