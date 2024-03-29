//
//  LiveViewModeViewController.swift
//  Emotion Detect
//
//  Created by Peter Entwistle on 19/02/2017.
//  Copyright © 2017 Peter Entwistle. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class LiveViewModeViewController: UIViewController {
    
    @IBOutlet weak var switchCamera: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emotionIcon: UIImageView!
    @IBOutlet weak var startbutton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
	private var sessionData: [SessionData] = []
    var currentResult: [Result] = []
    
    var currentCamera: CameraType!
    var openCVWrapper: OpenCVWrapper!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var startDetecting: Bool = false
    var hasRan: Bool = false
    var posNegMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startbutton = setupButton(button: startbutton)
        stopButton = setupButton(button: stopButton)
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
        
        // Empty the current result
        currentResult = []
    }
    
    @IBAction func stopDetecting(_ sender: Any) {
        startDetecting = false

        if hasRan {
            self.save(date: Date(), resultData: currentResult)
            
			// Switch tab
            let tabNumber = 2
            let navController = tabBarController?.viewControllers?[tabNumber] as! UINavigationController
            let sessionTab = navController.viewControllers[0] as! SessionTableViewController
			
			sessionTab.sessionData = sessionData
			self.tabBarController?.selectedIndex = tabNumber
        }
    }
    
    private func save(date: Date, resultData: [Result]) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // Create session data entity
        let entity = NSEntityDescription.entity(forEntityName: "SessionData",
                                                in: managedContext)!
        
        let session = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
        
        // Set the date of the session
        session.setValue(date, forKeyPath: "date")
        
        // For each result create resultData and add it to the session
        for result in resultData {
            
            let entity = NSEntityDescription.entity(forEntityName: "ResultData",
                                                   in: managedContext)!
            let resultData = NSManagedObject(entity: entity,
                                            insertInto: managedContext)
            
            resultData.setValue(result.text, forKey: "text")
            resultData.setValue(UIImagePNGRepresentation(result.image)! as NSData, forKey: "image")
            
            // Set relationship to session
            resultData.setValue(session, forKey: "sessionData")
        }
        
        // Save the session
        do {
            try managedContext.save()
            sessionData.append(session as! SessionData)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
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
    
    func setupButton(button: UIButton) -> UIButton {
        button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        return button
    }

    func showImage(imageName: String) {
        emotionIcon.image = UIImage(named: imageName)
        emotionIcon.isHidden = false
    }
    
    func hideImage () {
        emotionIcon.isHidden = true
    }
    
}

extension LiveViewModeViewController: EmotionDetectable {
    func detectedEmotion(name: String, response: DetectedResult?) {
        showImage(imageName: "happiness")
        print("\(name)!")
        currentResult.append(Result(image: (response?.frame)!, text: name))
    }
}

