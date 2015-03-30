//
//  ViewController.swift
//  Calculator
//
//  Created by freshlhy on 3/10/15.
//  Copyright (c) 2015 freshlhy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display.text = " "
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if digit == "." && display.text!.rangeOfString(".") != nil { return }
            if digit == "0" && display.text  == "0" { return }
            if digit != "." && display.text == "0" {
                display.text = digit
            } else {
                display.text = display.text! + digit
            }
        } else {
            display.text = (digit == ".") ? "0." : digit
            history.text = brain.description != "?" ? brain.description : ""
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            let displayText = display.text!
            if countElements(displayText) > 1 {
                display.text = dropLast(displayText)
            } else {
                display.text = "0"
            }
        }
    }
    
    @IBAction func storeVariable(sender: UIButton) {
        if let variable = last(sender.currentTitle!) {
            if displayValue != nil {
                brain.variableValues["\(variable)"] = displayValue
                if let result = brain.evaluate() {
                    displayValue = result
                } else {
                    displayValue = nil
                }
            }
        }
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func pushVariable(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let result = brain.pushOperand(sender.currentTitle!) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func clear() {
        display.text = "0"
        history.text = " "
        userIsInTheMiddleOfTypingANumber = false
        brain = CalculatorBrain()
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        
        set {
            if (newValue != nil) {
                display.text = "\(newValue!)"
                history.text = brain.description + " ="
            } else {
                display.text = " "
            }
        }
    }
    
}

