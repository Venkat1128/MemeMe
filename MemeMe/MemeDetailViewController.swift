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
    @IBAction func editsavedMeme(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MemeEditorNav") as! UINavigationController
        let memeEditorView:MemeEditorViewController = vc.viewControllers[0] as! MemeEditorViewController
        memeEditorView.cancelButton.isEnabled = true;
        memeEditorView.imagetobeEdited = meme.memedImage;
        // Alternative way to present the new view controller
        self.present(vc, animated: true, completion: nil)
    }

}
