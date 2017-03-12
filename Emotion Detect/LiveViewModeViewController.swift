//
//  LiveViewModeViewController.swift
//  Emotion Detect
//
//  Created by Peter Entwistle on 19/02/2017.
//  Copyright © 2017 Peter Entwistle. All rights reserved.
//

import UIKit
import AVFoundation

class LiveViewModeViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var switchCamera: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emotionIcon: UIImageView!
    
    var currentCamera: CameraType!
    var openCVWrapper: OpenCVWrapper!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var startDetecting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openCVWrapper = OpenCVWrapper()
        
        loadCamera(camera: .front)
        
        // Add image view
        //imageView = UIImageView(frame: CGRect(x: previewLayer.frame.maxX, y: previewLayer.frame.maxY, width: previewLayer.frame.width, height: previewLayer.frame.height))
        //self.view.addSubview(imageView)
        //self.view.bringSubview(toFront: imageView)
        
        emotionIcon.isHidden = true
        
        let myOutput = AVCaptureVideoDataOutput()
        myOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_32BGRA)]
        
        let queue: DispatchQueue = DispatchQueue(label: "myqueue",  attributes: [])
        
        //let captureOutput: CaptureOutput = CaptureOutput()
        myOutput.setSampleBufferDelegate(self, queue: queue)
        
        captureSession.addOutput(myOutput)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func switchCamera(_ sender: Any) {
        if (currentCamera == .front) {
            loadCamera(camera: .back)
        } else {
            loadCamera(camera: .front)
        }
    }
    
    @IBAction func startDetecting(_ sender: Any) {
        startDetecting = true
    }
    
    @IBAction func stopDetecting(_ sender: Any) {
        startDetecting = false
    }
    
    private func cameraDevices(position: AVCaptureDevicePosition) -> [AVCaptureDevice]? {
        return AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera],
                                               mediaType: AVMediaTypeVideo,
                                               position: position).devices
    }
    
    private func loadCamera(camera: CameraType) {
        captureSession = AVCaptureSession()
        currentCamera = camera
        
        var position = AVCaptureDevicePosition.front
        
        if camera == CameraType.back {
            position = AVCaptureDevicePosition.back
        }
        
        let selectedCamera = (cameraDevices(position: position)?.first)!
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: selectedCamera))
        } catch {
            print("Can't find camera")
        }
        
        //previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        //self.view.layer.addSublayer(previewLayer!)
        //previewLayer?.frame = self.view.layer.frame
        
        self.view.bringSubview(toFront: switchCamera)
        
        captureSession.startRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        DispatchQueue.main.sync(execute: {
            
            let image = CameraUtil.imageFromSampleBuffer(sampleBuffer)
            
            connection.videoOrientation = AVCaptureVideoOrientation.portrait
            
            if startDetecting {
                let response = openCVWrapper.detectAndDisplay(image)
                //self.imageView.image = response?.frame
                imageView.image = response?.frame
                
                if let emotion = response?.detectedEmotion {
                    
                    if emotion.emotion == .happiness {
                        showImage(imageName: "happiness")
                        print("Happiness!")
                        //detectedEmotion.text = "Happiness!"
                        //detectedEmotion.textColor = UIColor.red
                        //detectedEmotion.font = detectedEmotion.font.withSize(30)
                    } else {
                        hideImage()
                        print("None")
                        //detectedEmotion.text = "None"
                        //detectedEmotion.textColor = UIColor.black
                        //detectedEmotion.font = detectedEmotion.font.withSize(17)
                    }
                    //self.emotionImageView.image = emotion.frame
                }
            } else {
                imageView.image = image
            }
            
        })
    }
    
    private func showImage(imageName: String) {
        emotionIcon.image = UIImage(named: imageName)
        emotionIcon.isHidden = false
    }
    
    private func hideImage () {
        emotionIcon.isHidden = true
    }
    
}

