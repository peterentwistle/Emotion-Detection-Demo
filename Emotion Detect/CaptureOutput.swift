//
//  CaptureOutput.swift
//  Emotion Detect
//
//  Created by Peter Entwistle on 19/02/2017.
//  Copyright © 2017 Peter Entwistle. All rights reserved.
//
//Move to EmotionDetection framework
import AVFoundation
import EmotionCore

class CaptureOutput: NSObject {
}

extension CaptureOutput: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        DispatchQueue.main.sync(execute: {
            let openCVWrapper = OpenCVWrapper()
            
            let image = CameraUtil.imageFromSampleBuffer(sampleBuffer)
            
            let response = openCVWrapper.detectAndDisplay(image)
            //self.imageView.image = response?.frame
            
            if let emotion = response?.detectedEmotion {
                
                if emotion.emotion == .happiness {
                    print("Happiness!")
                    //detectedEmotion.text = "Happiness!"
                    //detectedEmotion.textColor = UIColor.red
                    //detectedEmotion.font = detectedEmotion.font.withSize(30)
                } else {
                    print("None")
                    //detectedEmotion.text = "None"
                    //detectedEmotion.textColor = UIColor.black
                    //detectedEmotion.font = detectedEmotion.font.withSize(17)
                }
                //self.emotionImageView.image = emotion.frame
            }
        })
    }

}
