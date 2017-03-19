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
    
    private var resultData: [ResultData] = []
    
    var currentCamera: CameraType!
    var openCVWrapper: OpenCVWrapper!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var startDetecting: Bool = false
    var hasRan: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        openCVWrapper = OpenCVWrapper()
        emotionIcon.isHidden = true
        loadCamera(camera: .front)
        hasRan = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        startDetecting = false
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
        hasRan = true
        resultData = []
    }
    
    @IBAction func stopDetecting(_ sender: Any) {
        startDetecting = false

        if hasRan {
            let tabNumber = 3
            let resultsTab = tabBarController?.viewControllers?[tabNumber] as! ResultsTableViewController
            resultsTab.resultData = resultData
            self.tabBarController?.selectedIndex = tabNumber
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        DispatchQueue.main.sync(execute: {
            
            let image = CameraUtil.imageFromSampleBuffer(sampleBuffer)
            
            connection.videoOrientation = AVCaptureVideoOrientation.portrait
            
            if startDetecting {
                let response = openCVWrapper.detectAndDisplay(image)
                imageView.image = response?.frame
                
                if let emotion = response?.detectedEmotion {
                    
                    if emotion.emotion == .happiness {
                        showImage(imageName: "happiness")
                        print("Happiness!")
                        
                        resultData.append(ResultData(image: (response?.frame)!, text: "Happiness"))
                    } else {
                        hideImage()
                        print("None")
                    }
                }
            } else {
                imageView.image = image
            }
            
        })
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
    
        do {
            let selectedCamera = (cameraDevices(position: position)?.first)
            try captureSession.addInput(AVCaptureDeviceInput(device: selectedCamera))
        } catch {
            print("Can't find camera")
        }
        
        self.view.bringSubview(toFront: switchCamera)
        
        captureSession.startRunning()
        addOutput()
    }
    
    private func addOutput() {
        let myOutput = AVCaptureVideoDataOutput()
        myOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_32BGRA)]
        
        let queue: DispatchQueue = DispatchQueue(label: "myqueue",  attributes: [])
        
        myOutput.setSampleBufferDelegate(self, queue: queue)
        captureSession.addOutput(myOutput)
    }

    private func showImage(imageName: String) {
        emotionIcon.image = UIImage(named: imageName)
        emotionIcon.isHidden = false
    }
    
    private func hideImage () {
        emotionIcon.isHidden = true
    }
    
}

