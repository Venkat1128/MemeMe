//
//  ViewController.swift
//  MemeMe
//
//  Created by Venkat Kurapati on 07/11/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        stylizeTextField(textField: topTextField)
        stylizeTextField(textField: bottomTextField)
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        self.shareButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    //MARK:- Stylize textfield 
    func stylizeTextField(textField: UITextField){
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
            NSStrokeWidthAttributeName: -2]
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center

    }
    //MARK:- Pick an Image from Album
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
       pickAnImageFromSource(sourceType: "album")
    }
    //MARK:- Pick an image from Camera
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
       pickAnImageFromSource(sourceType: "camera")
    }
    //MARK:- Pick an image source 
    func pickAnImageFromSource(sourceType : String) {
        let imagePicker = UIImagePickerController()
        if sourceType == "camera"  {
            imagePicker.sourceType = .camera
        }else{
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    //MARK:- Image Picker Deleage Mathods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.image = image
            self.shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Subscribe to keyboard notification for bottom text field
        if textField == bottomTextField {
            subscribeToKeyboardNotifications()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Unsubscribe to keyboard notification for bottom text field
        if textField == bottomTextField {
            unsubscribeFromKeyboardNotifications()
        }
        textField.resignFirstResponder()
    }
    
    //MARK:- Key board notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    //MARK: - Keyboard moves up on notification
    func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y -= getKeyboardHeight(_notificaion: notification)
    }
    func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y += getKeyboardHeight(_notificaion: notification)
    }
    
    func getKeyboardHeight(_notificaion :Notification) -> CGFloat{
        let userInof = _notificaion.userInfo
        let keyBoardSize = userInof![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.cgRectValue.height
    }
    
    //MARK:- save MemeMe 
    func saveMemeMe() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, orignalImage: imagePickerView.image, memedImage: generateMemedImage())
        Meme.saveMeme(meme: meme)
    }
    // Memed image
    func generateMemedImage() -> UIImage {
        self.navigationController?.navigationBar.isHidden = true
        self.toolBar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationController?.navigationBar.isHidden = false
        self.toolBar.isHidden = false
        return memedImage
    }
    @IBAction func shareMemeMe(_ sender: Any) {
        let memedImage = generateMemedImage()
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
        vc.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                self.saveMemeMe()
            }
        }
        present(vc, animated: true)
        
    }
}

