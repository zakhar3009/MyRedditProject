//
//  ViewController.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 07.02.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.titleLabel?.adjustsFontSizeToFitWidth = true
        shareButton.titleLabel?.minimumScaleFactor = 0.5

    }


}

