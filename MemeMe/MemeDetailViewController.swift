//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Venkat Kurapati on 20/11/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import UIKit
//MARK:- MemeDetailViewController: UIViewController
class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeDeatilImageView: UIImageView!
    // MARK: Properties
    
    var meme: Meme!
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.memeDeatilImageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

}
