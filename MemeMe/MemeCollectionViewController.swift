//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Venkat Kurapati on 17/11/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memecollectionviewcell"

class MemeCollectionViewController: UICollectionViewController {

    // MARK: Properties
    
    // Get ahold of some memes, for the table
    // This is an array of Meme instances.
    var memes = [Meme]()
     //MARK:- View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Read memes count on view load and if count is zero show Meme editor on screen 
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appdelegate.memes
        if memes.count == 0 {
            addNewMeme()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
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

    func addNewMeme(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MemeEditorNav")
        // Alternative way to present the new view controller
        self.present(vc, animated: true, completion: nil)
    }
}
