//
//  LiveViewModeViewController+AVCaptureVideoDataOutputSampleBufferDelegate.swift
//  Emotion Detect
//
//  Created by Peter Entwistle on 22/04/2017.
//  Copyright © 2017 Peter Entwistle. All rights reserved.
//

extension LiveViewModeViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        DispatchQueue.main.sync(execute: {
            
            let image = CameraUtil.imageFromSampleBuffer(sampleBuffer)
            
            connection.videoOrientation = AVCaptureVideoOrientation.portrait
            
            if startDetecting {
                let response = openCVWrapper.detectAndDisplay(image)
                imageView.image = response?.frame
                
                if let emotion = response?.detectedEmotion {
                    
                    switch emotion.emotion {
                    case .happiness:
                        detectedEmotion(name: "Happiness", response: response)
                    case .anger:
                        detectedEmotion(name: "Anger", response: response)
                    case .contempt:
                        detectedEmotion(name: "Contempt", response: response)
                    case .fear:
                        detectedEmotion(name: "Fear", response: response)
                    case .neutral:
                        detectedEmotion(name: "Neutral", response: response)
                    case .sadness:
                        detectedEmotion(name: "Sadness", response: response)
                    case .surprise:
                        detectedEmotion(name: "Surprise", response: response)
                    case .disgust:
                        detectedEmotion(name: "Disgust", response: response)
                    default:
                        hideImage()
                        print("None")
                    }
                    
                }
            } else {
                imageView.image = image
            }
            
        })
    }
    
}
