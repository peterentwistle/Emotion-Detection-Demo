//
//  LiveViewModeViewController.swift
//  Emotion Detect
//
//  Created by Peter Entwistle on 19/02/2017.
//  Copyright © 2017 Peter Entwistle. All rights reserved.
//

import UIKit
import AVFoundation

class LiveViewModeViewController: UIViewController {
	
    @IBOutlet weak var switchCamera: UIButton!
	
	var currentCamera: CameraType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        loadCamera(camera: .front)
		
        let myOutput = AVCaptureVideoDataOutput()
        myOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_32BGRA)]
        
        //let queue: DispatchQueue = DispatchQueue(label: "myqueue",  attributes: [])
        
        //let captureOutput: CaptureOutput = CaptureOutput()
        //myOutput.setSampleBufferDelegate(captureOutput, queue: queue)
        
        //captureSession.addOutput(myOutput)
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
	
	private func cameraDevices(position: AVCaptureDevicePosition) -> [AVCaptureDevice]? {
		return AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera],
		                                                     mediaType: AVMediaTypeVideo,
		                                                     position: position).devices
	}
	
	private func loadCamera(camera: CameraType) {
		let captureSession = AVCaptureSession()
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
		
		let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

		self.view.layer.addSublayer(previewLayer!)
		previewLayer?.frame = self.view.layer.frame
		
		self.view.bringSubview(toFront: switchCamera)
		
		captureSession.startRunning()
	}
}

