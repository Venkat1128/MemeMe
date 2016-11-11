//
//  Meme.swift
//  MemeMe
//
//  Created by Venkat Kurapati on 10/11/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import Foundation
import UIKit
struct Meme {
    let topText : String
    let bottomText : String
    let orignalImage : UIImage!
    let memedImage : UIImage!
    // Save MemeMe
    static func saveMeme(meme : Meme){
        let memeClassObject = HelperClass.init(meMe: meme)
        NSKeyedArchiver.archiveRootObject(memeClassObject, toFile: HelperClass.path())
    }
    // Retrive MemeMe
    static func retrieveMeme() -> Meme? {
        let memeClassObject = NSKeyedUnarchiver.unarchiveObject(withFile: HelperClass.path()) as? HelperClass
        return memeClassObject?.meMe
    }
}
// Meme Helperclass for implementing NSCoding
extension Meme{
    
    class HelperClass: NSObject, NSCoding {
        var meMe : Meme?
        init(meMe : Meme) {
            self.meMe = meMe
            super.init()
            
        }
        class func path() -> String {
            let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let path = documentsPath?.appending("/Meme")
            return path!
        }
        
        required init?(coder  aDeocoder:NSCoder) {
            guard let topText = aDeocoder.decodeObject(forKey: "topText") as? String else {meMe = nil; super.init(); return nil }
            guard let bottomText = aDeocoder.decodeObject(forKey: "bottomText") as? String else { meMe = nil;super.init();  return nil }
            guard let orignalImage = aDeocoder.decodeObject(forKey: "orignalImage") as? UIImage else { meMe = nil;super.init();  return nil }
            guard let memedImage = aDeocoder.decodeObject(forKey: "memedImage") as? UIImage else { meMe = nil;super.init();  return nil }
            meMe = Meme(topText:topText,bottomText:bottomText,orignalImage:orignalImage,memedImage:memedImage)
            super.init()
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(meMe!.topText, forKey: "topText")
            aCoder.encode(meMe!.bottomText, forKey: "bottomText")
            aCoder.encode(meMe!.orignalImage, forKey: "orignalImage")
            aCoder.encode(meMe!.memedImage, forKey: "memedImage")
        }
    }
}
