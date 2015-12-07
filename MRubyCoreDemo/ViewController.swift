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

        guard let context = try? MRBContext() else { return }

        print(context.topSelf)

        do {
            print(try context.evaluateScript("1 + y"))
        }
        catch {
            print(error)
        }

        do {
            print(try context.evaluateScript("$stdout"))
            print(try context.evaluateScript("x = 1.0"))
            print(try context.evaluateScript(":a"))
            print(try context.evaluateScript("1 + 1"))
            print(try context.evaluateScript("'a'"))
            print(try context.evaluateScript("1.2 * x"))
            print(try context.evaluateScript("p 'hello'"))
            print(try context.evaluateScript("nil"))
            print(try context.evaluateScript("false"))
            print(try context.evaluateScript("true"))
            print(try context.evaluateScript("Proc.new { |n| n * n }"))
            print(try context.evaluateScript("String"))
            print(try context.evaluateScript("Kernel"))
            print(try context.evaluateScript("[1, 2.0, 'a']"))
            print(try context.evaluateScript("{a: 3, b: '7', :c => [36], 'd' => {}}"))
            print(try context.evaluateScript("class"))
        }
        catch {
            print(error)
        }

        if let proc = try? context.evaluateScript("Proc.new { |n| n * n * n }") {
            let x:mrb_int = proc.callMethod("call", withParameters: [try! context.evaluateScript("3")])
            print(x)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

