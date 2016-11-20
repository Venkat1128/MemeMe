//
//  ViewController.swift
//  MemeMe
//
//  Created by Venkat Kurapati on 07/11/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//


import UIKit
protocol MemeEditorViewControllerDelegate: class {
    func updateMemesList()
}
// MARK:- MemeEditorViewController
class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    weak var delegate:MemeEditorViewControllerDelegate?
    var imagetobeEdited:UIImage!
    //MARK:- Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        topTextField.text = "Top"
        bottomTextField.text = "Bottom"
        stylizeTextField(textField: topTextField)
        stylizeTextField(textField: bottomTextField)
        topTextField.delegate = self
        bottomTextField.delegate = self
        shareButton.isEnabled = false
        if imagetobeEdited != nil {
            self.imagePickerView.image = imagetobeEdited
            shareButton.isEnabled = true
        }
        
        let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if appdelegate.memes.count == 0 {
            cancelButton.isEnabled = false;
        }
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
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -2]
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center

    }
    //MARK:- Pick an Image based on tag value
    @IBAction func pickAnImageAction(_ sender: AnyObject) {
        if sender.tag == 0 {
            pickAnImageFromSource(sourceType: .camera) // Open Camers
        }else{
            pickAnImageFromSource(sourceType: .photoLibrary) // Open Photo Library
        }
    }
    
    //MARK:- Pick an image source 
    func pickAnImageFromSource(sourceType : UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    //MARK:- Image Picker Deleage Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.image = image
            shareButton.isEnabled = true
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
            bottomTextField.text = ""
            bottomTextField.text = textField.text
            subscribeToKeyboardNotifications()
        }else{
            topTextField.text = ""
            topTextField.text = textField.text
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
        self.navigationController?.navigationBar.isHidden = true
        view.frame.origin.y = getKeyboardHeight(notification) * -1
    }
    func keyboardWillHide(_ notification:Notification){
        self.navigationController?.navigationBar.isHidden = false
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notificaion :Notification) -> CGFloat{
        let userInof = notificaion.userInfo
        let keyBoardSize = userInof![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.cgRectValue.height
    }
    
    //MARK:- save MemeMe 
    func saveMemeMe() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, orignalImage: imagePickerView.image, memedImage: generateMemedImage())
        
        // Add it to memes array in app delegate
        let Object = UIApplication.shared.delegate
        let appDelegate = Object as! AppDelegate
        appDelegate.memes.append(meme)
        delegate?.updateMemesList()
        imagetobeEdited = nil;
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- Generate Memed image
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
    //MARK:- Share my Meme
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
    @IBAction func clearMemeImage(_ sender: Any) {
        shareButton.isEnabled = false
        imagetobeEdited = nil
        dismiss(animated: true, completion: nil)
    }
    // MARK:- unsubscibe for keyboard notification while change orienation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        bottomTextField.resignFirstResponder()
        unsubscribeFromKeyboardNotifications()
    }
}



