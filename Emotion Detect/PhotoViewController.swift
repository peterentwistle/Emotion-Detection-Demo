//
//  PhotoViewController.swift
//  Emotion Detect
//
//  Created by Peter Entwistle on 22/04/2017.
//  Copyright © 2017 Peter Entwistle. All rights reserved.
//

import UIKit
import MobileCoreServices

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    var openCVWrapper: OpenCVWrapper!
    var photo: UIImage?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detectedEmotionValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        // Do any additional setup after loading the view.
        openCVWrapper = OpenCVWrapper()
        detectedEmotionValue.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func photoFromLibrary(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeImage as String]
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func analyseImage(_ sender: UIBarButtonItem) {
        if imageView.image != nil {
            DispatchQueue.main.async {
                self.detectedEmotionValue.text = "Analysing..."
                self.imageView.image = self.photo
                DispatchQueue.main.async(execute: {
                    if let image = self.photo {
                        
                        let fixedImage = self.fixOrientation(image: image)
                        
                        let response = self.openCVWrapper.detectAndDisplay(fixedImage, posNegMode: self.getPosNegValue())
                        
                        guard let emotion = response?.detectedEmotion else {
                            self.detectedEmotion(name: "None", response: response)
                            return
                        }
                        
                        switch emotion.emotion {
                        case .happiness:
                            self.detectedEmotion(name: "Happiness", response: response)
                        case .anger:
                            self.detectedEmotion(name: "Anger", response: response)
                        case .contempt:
                            self.detectedEmotion(name: "Contempt", response: response)
                        case .fear:
                            self.detectedEmotion(name: "Fear", response: response)
                        case .neutral:
                            self.detectedEmotion(name: "Neutral", response: response)
                        case .sadness:
                            self.detectedEmotion(name: "Sadness", response: response)
                        case .surprise:
                            self.detectedEmotion(name: "Surprise", response: response)
                        case .disgust:
                            self.detectedEmotion(name: "Disgust", response: response)
                        case .positive:
                            self.detectedEmotion(name: "Positive", response: response)
                        case .negative:
                            self.detectedEmotion(name: "Negative", response: response)
                        default:
                            self.detectedEmotion(name: "None", response: response)
                        }

                    }
                })
            }
        }
    }
    
    func getPosNegValue() -> Bool {
        let liveView = self.tabBarController?.viewControllers?[0] as! LiveViewModeViewController
        return liveView.posNegMode
    }
    
    // MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let photo = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = photo
        self.photo = photo
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func fixOrientation(image: UIImage) -> UIImage {
        
        if (image.imageOrientation == .up) {
            return image;
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        
        let normalisedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalisedImage;
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

extension PhotoViewController: EmotionDetectable {
    
    func detectedEmotion(name: String, response: DetectedResult?) {
        imageView.image = response?.frame
        detectedEmotionValue.text = name
    }
    
}

