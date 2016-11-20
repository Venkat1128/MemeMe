//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Venkat Kurapati on 17/11/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memecollectionviewcell"

class MemeCollectionViewController: UICollectionViewController,MemeEditorViewControllerDelegate {
    
    // MARK: Properties
    
    // Get ahold of some memes, for the table
    // This is an array of Meme instances.
    var memes = [Meme]()
    var appdelegate =  AppDelegate()
    //MARK:- View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sent Memes"
        // Read memes count on view load and if count is zero show Meme editor on screen
        appdelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appdelegate.memes
        if memes.count == 0 {
            addNewMeme()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        appdelegate = UIApplication.shared.delegate as! AppDelegate
        if self.memes.count != appdelegate.memes.count  {
            updateMemesList()
        }
        
    }
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let memeObject:Meme = self.memes[(indexPath as NSIndexPath).row]
        cell.memeImageView.image = memeObject.memedImage
        // Configure the cell
        
        return cell
    }
    //MARK:- add Action button
    @IBAction func addNewMeme(_ sender: Any) {
        addNewMeme()
    }
    //MARK:- Show Meme editor
    func addNewMeme(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MemeEditorNav") as! UINavigationController
        let memeEditorView:MemeEditorViewController = vc.viewControllers[0] as! MemeEditorViewController
        memeEditorView.delegate = self
        // Alternative way to present the new view controller
        self.present(vc, animated: true, completion: nil)
    }
    //MARK:- Meme editor delegete method
    func updateMemesList() {
        appdelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appdelegate.memes
        self.collectionView?.reloadData()
    }
}
