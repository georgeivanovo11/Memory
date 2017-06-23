//
//  AddSegmentVC.swift
//  Memory
//
//  Created by Георгий Мамардашвили on 23.06.17.
//  Copyright © 2017 Георгий Мамардашвили. All rights reserved.
//

import UIKit

class AddSegmentVC: UIViewController
{
    var engLB: UILabel?
    var engTF: UITextField?
    var rusLB: UILabel?
    var rusTF: UITextField?
    var topicLB: UILabel?
    var topicTF: UITextField?
    var antLB: UILabel?
    var antTF: UITextField?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Segment"
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        setView()
    }
}

extension AddSegmentVC
{
    @objc func save()
    {
        
    }
    
    @objc func engSearch()
    {
        let VC = FindItemVC()
        VC.name = "Enter english word"
        VC.segmentVC = self
        self.navigationController?.pushViewController(VC, animated: true)
        engTF?.endEditing(true)
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
        view.addSubview(topicTF!)
        topicTF?.translatesAutoresizingMaskIntoConstraints = false
        topicTF?.leftAnchor.constraint(equalTo: (topicLB?.rightAnchor)!, constant: 5).isActive=true
        topicTF?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive=true
        topicTF?.topAnchor.constraint(equalTo: (rusTF?.bottomAnchor)!, constant: 15).isActive=true
        topicTF?.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        antLB = UILabel()
        antLB?.text = "Ant:"
        antLB?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(antLB!)
        antLB?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive=true
        antLB?.widthAnchor.constraint(equalToConstant: 40).isActive=true
        antLB?.topAnchor.constraint(equalTo: (topicLB?.bottomAnchor)!, constant: 15).isActive=true
        antLB?.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        antTF = UITextField()
        antTF?.borderStyle = .roundedRect
        view.addSubview(antTF!)
        antTF?.translatesAutoresizingMaskIntoConstraints = false
        antTF?.leftAnchor.constraint(equalTo: (antLB?.rightAnchor)!, constant: 5).isActive=true
        antTF?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive=true
        antTF?.topAnchor.constraint(equalTo: (topicTF?.bottomAnchor)!, constant: 15).isActive=true
        antTF?.heightAnchor.constraint(equalToConstant: 35).isActive=true
    }
}









