//
//  VideoViewController.swift
//  Emotion Detect
//
//  Created by Peter Entwistle on 22/04/2017.
//  Copyright © 2017 Peter Entwistle. All rights reserved.
//

import UIKit
import MobileCoreServices

class VideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let picker = UIImagePickerController()
    var openCVWrapper: OpenCVWrapper!
    
    var positiveCount: Int = 0
    var negativeCount: Int = 0
    var neutralCount: Int = 0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var positiveLabel: UILabel!
    @IBOutlet weak var negativeLabel: UILabel!
    @IBOutlet weak var neutralLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        openCVWrapper = OpenCVWrapper()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func videoFromLibrary(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeMovie as String]
        present(picker, animated: true, completion: nil)
    }

    // MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
  
        let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL
        imageView.contentMode = .scaleAspectFit
        //imageView.image = video
        dismiss(animated:true, completion: nil)
        
        resetCounters()
        
        //inputUrl = URL(fileURLWithPath: filePath)
        //var movie = AVURLAsset(videoURL, options: nil)
        let video = AVAsset(url: videoURL! as URL)
        let tracks: [Any] = video.tracks(withMediaType: AVMediaTypeVideo)
        let track: AVAssetTrack? = tracks.first as? AVAssetTrack
        //let error: Error? = nil
        let assetReader = try? AVAssetReader(asset: video)
        
        let options: [AnyHashable: Any] = [
            kCVPixelBufferPixelFormatTypeKey as AnyHashable : Int(kCVPixelFormatType_32ARGB)
        ]
        
        let assetReaderTrackOutput = AVAssetReaderTrackOutput(track: track!, outputSettings: options as? [String : Any])
        assetReader?.add(assetReaderTrackOutput)
        assetReader?.startReading()
        while assetReader?.status == .reading {
            let sampleBuffer: CMSampleBuffer? = assetReaderTrackOutput.copyNextSampleBuffer()
            if sampleBuffer != nil {
                //DispatchQueue.global().async(execute: {
                    DispatchQueue.main.async(execute: {
                        self.processFrames(sampleBuffer: sampleBuffer!)
                    })
                //})
            }
        }
    }
    
    func processFrames(sampleBuffer: CMSampleBuffer) {
        let image = CameraUtil.imageFromSampleBuffer(sampleBuffer)
        
        let response = openCVWrapper.detectAndDisplay(image, posNegMode: true)
        //imageView.image = image// response?.frame
        
        if let emotion = response?.detectedEmotion {
            
            switch emotion.emotion {
            case .neutral:
                detectedEmotion(name: "Neutral", response: response)
                neutralCount += 1
                neutralLabel.text = "Neutral \((Double(neutralCount) / Double(totalCount()) * 100))%"
            case .positive:
                detectedEmotion(name: "Positive", response: response)
                positiveCount += 1
            case .negative:
                detectedEmotion(name: "Negative", response: response)
                negativeCount += 1
            default:
                print("None")
            }
            
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func resetCounters() {
        positiveCount = 0
        negativeCount = 0
        neutralCount = 0
    }
    
    func totalCount() -> Int {
        return positiveCount + negativeCount + neutralCount
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

extension VideoViewController: EmotionDetectable {
    func detectedEmotion(name: String, response: DetectedResult?) {
        imageView.image = response?.frame
    }
}
