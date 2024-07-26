//
//  ViewController.swift
//  JCSwiftRestful
//
//  Created by James on 06/17/2024.
//  Copyright (c) 2024 James. All rights reserved.
//

import JCSwiftRestful
import UIKit

private struct IpTestRequestData: JCRequestData {
  struct Response: Codable {
    var ip: String
  }

  var apiPath: String {
    "http://ip.jsontest.com"
  }
}

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
