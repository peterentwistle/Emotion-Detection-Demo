//
//  DetectedEmotionViewController.swift
//  Emotion Detect
//
//  Created by Peter Entwistle on 19/03/2017.
//  Copyright © 2017 Peter Entwistle. All rights reserved.
//

import UIKit

class DetectedEmotionViewController: UIViewController {

    @IBOutlet weak var viewTitle: UINavigationItem!
    @IBOutlet weak var emotionImage: UIImageView!
    
    var data: ResultData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replaceTitleValue(textField: viewTitle, value: (data.value(forKeyPath: "text") as! String))
        emotionImage.image = UIImage(data: (data.value(forKeyPath: "image") as! NSData) as Data)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func replaceTitleValue(textField: UINavigationItem, value: String) {
        textField.title = textField.title?.replacingOccurrences(of: "(value)", with: value)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
