//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Venkat Kurapati on 17/11/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import UIKit
//MARK:- MemeTableViewController: UITableViewController
class MemeTableViewController: UITableViewController {
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
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appdelegate.memes
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!
        
        // Configure the cell...
        let memeObject:Meme = self.memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = memeObject.memedImage
        cell.textLabel?.text = memeObject.topText + "......" + memeObject.bottomText
        return cell
    }
    
    @IBAction func AddNewMeme(_ sender: Any) {
        addNewMeme()
    }
    
    func addNewMeme(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MemeEditorNav")
        // Alternative way to present the new view controller
        self.present(vc, animated: true, completion: nil)
    }
    
}
