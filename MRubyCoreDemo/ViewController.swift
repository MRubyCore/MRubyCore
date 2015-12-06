//
//  ViewController.swift
//  MRubyCoreDemo
//
//  Created by Zhang Yi on 15/12/3.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import UIKit
import MRubyCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let context = MRBContext()
        print(context.evaluateScript("x = 1.0"))
        print(context.evaluateScript(":a"))
        print(context.evaluateScript("1 + 1"))
        print(context.evaluateScript("'a'"))
        print(context.evaluateScript("1.2 * x"))
        print(context.evaluateScript("p 'hello'"))
        print(context.evaluateScript("nil"))
        print(context.evaluateScript("false"))
        print(context.evaluateScript("true"))
        print(context.evaluateScript("Proc.new { |n| n * n }"))
        print(context.evaluateScript("String"))
        print(context.evaluateScript("Kernel"))
        print(context.evaluateScript("[1, 2.0, 'a']"))
        print(context.evaluateScript("{a: 3, b: '7', :c => [36], 'd' => {}}"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

