//
//  VC.swift
//  Memory
//
//  Created by Георгий Мамардашвили on 22.06.17.
//  Copyright © 2017 Георгий Мамардашвили. All rights reserved.
//

import UIKit


//MARK: Keyboard
extension UIViewController
{
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

//MARK: Error message
extension UIViewController
{
    func showError(text: String)
    {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true)
    }
}

