//
//  TestViewController.swift
//  EZBook
//
//  Created by Paing Zay on 25/11/23.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func goToRead(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRead", sender: self)
    }
    @IBAction func goToChapters(_ sender: Any) {
        performSegue(withIdentifier: "goToChapters", sender: self)
    }
}
