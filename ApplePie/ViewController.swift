//
//  ViewController.swift
//  ApplePie
//
//  Created by kevin on 2018/5/4.
//  Copyright © 2018年 KevinChang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet var letterButton: [UIButton]!
    @IBOutlet weak var corretWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func letterBtnPressed (_ sender: UIButton){
        sender.isEnabled = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

