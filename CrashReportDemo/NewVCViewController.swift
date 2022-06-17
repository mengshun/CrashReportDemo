//
//  NewVCViewController.swift
//  CrashReportDemo
//
//  Created by mengshun on 2022/6/13.
//

import UIKit

class NewVCViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        CrashEye.add(delegate: self)

        // Do any additional setup after loading the view.
    }

    @IBAction func crashAction(_ sender: Any) {
        let a = [1]
        a[2]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
