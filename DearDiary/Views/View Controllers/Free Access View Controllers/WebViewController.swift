//
//  WebViewController.swift
//  DearDiary
//
//  Created by  Ronit D. on 7/19/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var infoWebView: WKWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let string = "https://arm8wti2t2.wixsite.com/website"
        let url = URL(string: string)
        let request = URLRequest(url: url!)
        infoWebView.load(request)
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
