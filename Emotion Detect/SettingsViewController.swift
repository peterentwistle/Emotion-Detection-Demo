//
//  SettingsViewController.swift
//  Emotion Detect
//
//  Created by Peter Entwistle on 22/04/2017.
//  Copyright © 2017 Peter Entwistle. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func posNegToggled(_ sender: UISwitch) {
        let liveView = self.tabBarController?.viewControllers?[0] as! LiveViewModeViewController

        liveView.posNegMode = sender.isOn
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
