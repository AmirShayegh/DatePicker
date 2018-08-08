//
//  ViewController.swift
//  DatePicker
//
//  Created by amirshayegh on 08/08/2018.
//  Copyright (c) 2018 amirshayegh. All rights reserved.
//

import UIKit
import DatePicker

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let fd = DatePicker()
        fd.setup { (date) in
            print(date)
        }

        fd.display(in: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

