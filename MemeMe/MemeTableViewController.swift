//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Venkat Kurapati on 17/11/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import UIKit
//MARK:- MemeTableViewController: UITableViewController
class MemeTableViewController: UITableViewController,MemeEditorViewControllerDelegate {
    // MARK: Properties
    
    // Get ahold of some memes, for the table
    // This is an array of Meme instances.
    var memes = [Meme]()
    var appdelegate =  AppDelegate()
    //MARK:- View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sent Memes"
        // Read memes count on view load and if count is zero show Meme editor on screen
        appdelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appdelegate.memes
        if memes.count == 0 {
            addNewMeme()
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appdelegate = UIApplication.shared.delegate as! AppDelegate
        if self.memes.count != appdelegate.memes.count  {
            updateMemesList()
        }
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    //MARK:- add Action button
    @IBAction func AddNewMeme(_ sender: Any) {
        addNewMeme()
    }
    //MARK:- Show Meme editor
    func addNewMeme(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MemeEditorNav") as! UINavigationController
        let memeEditorView:MemeEditorViewController = vc.viewControllers[0] as! MemeEditorViewController
        memeEditorView.delegate = self
        memeEditorView.cancelButton.isEnabled = true;
        // Alternative way to present the new view controller
        self.present(vc, animated: true, completion: nil)
    }
     //MARK:- Meme editor delegete method
    func updateMemesList() {
        appdelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appdelegate.memes
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.tableView.beginUpdates()
            memes.remove(at: indexPath.row)
            appdelegate.memes = memes
            self.tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
            self.tableView.endUpdates()
            
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
