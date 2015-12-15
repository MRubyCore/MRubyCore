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
            print(try context.evaluateScript("def f(name, extras = \"goodbye\"); puts \"Hello, #{name}, and #{extras}.\"; return name, extras; end"))
            print(try context.evaluateScript("f(1)"))
        }
        catch {
            print(error)
        }

        do {
            let proc = try context.evaluateScript("Proc.new { |n| n * n * n }")
            let x = try proc.send("call", parameters: [3])
            print(x)

            let s = "再见"
            let y = try context.topSelf.send("f", parameters: [[M_PI], ["name": s]])
            print(y)
        }
        catch {
            print(error)
        }

        let x = try! context.evaluateScript("1")
        let y = try! x.send("to_s", parameters: [])
        print(x, y)

        print(try! context.evaluateScript("[1, 2.0, 'a']").arrayValue)
        print(try! context.evaluateScript("{a: 3, b: '7', :c => [36], 'd' => {}}").dictionaryValue)

        print(("a".apply(context: context) as! MRBRangeElementValue).successor())

        print(try! context.evaluateScript("1 .. 10").rangeValue)
        print(try! context.evaluateScript("'a' ... 'z'").rangeValue)
        print((1...10).apply(context: context))
        print(Array(1...10).apply(context: context))
        print([1, 2, 3].apply(context: context))
        print([1: 2].apply(context: context))

        do {
            print(try context.evaluateScript("a = 1; b = [1, 2, 3]; c = \"6\""))
            print(try context.evaluateScript("a"))
            print(try context.evaluateScript("b"))
            print(try context.evaluateScript("c"))

            let classA = try context.evaluateScript("class A; end")
            let instanceA = try context.evaluateScript("A.new")
            try classA.evaluateScript("def f; p 123; end")
            print(try instanceA.send("f", parameters: []))

            print(try "1".apply(context: context).evaluateScript("xxxx = 9"))
        }
        catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

