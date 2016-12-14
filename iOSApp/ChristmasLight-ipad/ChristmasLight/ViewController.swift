//
//  ViewController.swift
//  SwiftHUEColorPicker
//
//  Created by Maxim Bilan on 5/6/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

import UIKit
import Alamofire
//import SwiftHUEColorPicker



class ViewController: UIViewController, SwiftHUEColorPickerDelegate {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    //@IBOutlet weak var colorView: UIView!
    @IBOutlet weak var christmasTreeIcon: UIImageView!
    @IBOutlet weak var circle: UIView!
    @IBOutlet weak var light1: UIView!
    @IBOutlet weak var light2: UIView!
    @IBOutlet weak var light3: UIView!
    @IBOutlet weak var light4: UIView!
    @IBOutlet weak var light5: UIView!
    @IBOutlet weak var light6: UIView!
    @IBOutlet weak var light7: UIView!
    @IBOutlet weak var light8: UIView!
    @IBOutlet weak var light9: UIView!
    var lights: [UIView] = []
    
    // Delay
    var timer = Timer()
    
    // MARK: - Vertical pickers
    
    @IBOutlet weak var verticalColorPicker: SwiftHUEColorPicker!
    @IBOutlet weak var verticalSaturationPicker: SwiftHUEColorPicker!
    @IBOutlet weak var verticalBrightnessPicker: SwiftHUEColorPicker!
    @IBOutlet weak var verticalAlphaPicker: SwiftHUEColorPicker!
    var colorPickers : [SwiftHUEColorPicker] = []
    
    
    @IBOutlet weak var sendButton: UIButton!
    
    var rgbColor: String = ""
    var parameters : Parameters = [:]
    var isPaused : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")
        self.container.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
        backgroundImage.bringSubview(toFront: container)
        
        /* Circle */
        circle.layer.masksToBounds = true
        circle.layer.cornerRadius = 60
        
        colorPickers = [verticalColorPicker, verticalSaturationPicker, verticalBrightnessPicker, verticalAlphaPicker]
        
        lights = [circle, light1, light2, light3, light4, light5, light6, light7, light8, light9]
        
        
        for colorPicker in colorPickers {
            colorPicker.delegate = self
            colorPicker.direction = SwiftHUEColorPicker.PickerDirection.vertical
            colorPicker.cornerRadius = 50
            colorPicker.labelBackgroundColor = UIColor.white
            colorPicker.labelFontColor = UIColor.clear
        }
        
        verticalColorPicker.type = SwiftHUEColorPicker.PickerType.color

        verticalSaturationPicker.type = SwiftHUEColorPicker.PickerType.saturation
        
        verticalBrightnessPicker.type = SwiftHUEColorPicker.PickerType.brightness

        verticalAlphaPicker.type = SwiftHUEColorPicker.PickerType.alpha
        
        container.addSubview(verticalColorPicker)
        
        

    }
    
    // Executed when picked color changed
    func valuePicked(_ color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        
        //let deadlineTime = DispatchTime.now() + .seconds(3)
        //DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            // Set changed color to lightes
            for light in self.lights{
                light.backgroundColor = color
            }
            self.sendButton.layer.borderColor = color.cgColor

        // Color Picker bar change color acroding to the color user picked before
            switch type {
            case SwiftHUEColorPicker.PickerType.color:
                self.verticalSaturationPicker.currentColor = color
                self.verticalBrightnessPicker.currentColor = color
                self.verticalAlphaPicker.currentColor = color
                break
            case SwiftHUEColorPicker.PickerType.saturation:
                self.verticalColorPicker.currentColor = color
                self.verticalBrightnessPicker.currentColor = color
                self.verticalAlphaPicker.currentColor = color
                break
            case SwiftHUEColorPicker.PickerType.brightness:
                self.verticalColorPicker.currentColor = color
                self.verticalSaturationPicker.currentColor = color
                self.verticalAlphaPicker.currentColor = color
                break
            case SwiftHUEColorPicker.PickerType.alpha:
                self.verticalColorPicker.currentColor = color
                self.verticalSaturationPicker.currentColor = color
                self.verticalBrightnessPicker.currentColor = color
                break
            }

            getRGB(color: color)
        
        //}
    }
    
    func getRGB(color: UIColor) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        parameters = [
            "rgb":["\(Int(r*255))","\(Int(g*255/1))","\(Int(b*255/1))","\(a)"]
        ]
        print("parameters: \(parameters)")
        
        // Auto send data to server
        sendToServer()
    }
    
    @IBAction func sendRGB(_ sender: Any) {
        sendToServer()
    }
    
    func sendToServer(){
        //print("Input Ip Again: \(UserDefaults.standard.value(forKey: "IP")!)")
        
        if let inputIP : String = UserDefaults.standard.value(forKey: "IP") as! String?{
            NetWorHandler().sendData(parameters: parameters, ipAddress: inputIP)
        }else{
            var testingIP = NetWorHandler().readIPfromFile()
            NetWorHandler().sendData(parameters: parameters, ipAddress: testingIP)
        }
        
        //NetWorHandler().readIPfromFile()
        NSLog("Auto send to server")
    }
    
    @IBAction func showIpInput(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Enter Your IP Address", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField{
            (textField) in
            textField.placeholder = "Please Enter your IP address"
        }
        let deleteAction = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
            print("Delete button tapped")
        })
        alertController.addAction(deleteAction)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            if let input = alertController.textFields?[0]{
                
                guard let ip = input.text, !ip.isEmpty else{
                    // When input is empty
                    
                    let warning = UIAlertController(title: "Empty Input", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    self.present(warning, animated: true, completion: {
                        warning.view.superview?.isUserInteractionEnabled = true
                        warning.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("warningClose"))))
                    })
                    //warning.dismiss(animated: true, completion: nil)
                    return
                }
                // When input is not empty
                var inputString = "http://" + input.text! + ":5000"
                UserDefaults.standard.setValue(inputString, forKey: "IP")
                print("Input Ip: \(UserDefaults.standard.value(forKey: "IP"))")
                
            }else{
                print("inside else")
                
            }
            
        })
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
        
    }

   /*4
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        //super.touchesMoved(touches, withEvent: event)
        
        let touch: UITouch = touches.first! as UITouch

        if (touch.view == container){
            print("touchesEnded | This is an ImageView")
        }else{
            print("touchesEnded | This is not an ImageView")
            //sendToServer()
        }

    }
    */
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches Canclled")
    }
    

    

    
    
   /*
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesMoved")
        print("touchesMoved")
        print("touchesMoved")
        print("touchesMoved")
    }
 */
    
    
    
    
    func delay(_ delay:Double) {
        let delayTime = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            print("Dealying, Now: \(DispatchTime.now())")
        }
        
    }


}








