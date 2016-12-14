//
//  ViewController.swift
//  SwiftHUEColorPicker
//
//  Created by Shan Jiang on 5/6/15.
//  Copyright (c) 2016 Shan Jiang. All rights reserved.
//
// Icon from: <a href="https://icons8.com/web-app/8113/Menu-Filled">

import UIKit
import Alamofire
//import SwiftHUEColorPicker



class ViewController: UIViewController, SwiftHUEColorPickerDelegate, UITabBarControllerDelegate, UITabBarDelegate{
    
    @IBOutlet weak var container: UIView!
    //@IBOutlet weak var colorView: UIView!
    @IBOutlet weak var christmasTreeIcon: UIImageView!


 
    @IBOutlet weak var light0: UIImageView!
  

    @IBOutlet weak var light3: UIImageView!
  
    @IBOutlet weak var light5: UIImageView!
    @IBOutlet weak var light6: UIImageView!
    @IBOutlet weak var light7: UIImageView!
    @IBOutlet weak var light8: UIImageView!
   

    @IBOutlet weak var light11: UIImageView!
    @IBOutlet weak var light12: UIImageView!
  
    @IBOutlet weak var light13: UIImageView!
    @IBOutlet weak var light15: UIImageView!

    @IBOutlet weak var light18: UIImageView!
    @IBOutlet weak var light19: UIImageView!

    
    @IBOutlet weak var switchButton: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!

    var lights: [UIImageView] = []
    var starColor: UIColor = UIColor.yellow
    
    // Delay
    var timer = Timer()
    
    // MARK: - Vertical pickers
    
    @IBOutlet weak var verticalColorPicker: SwiftHUEColorPicker!
    var colorPickers : [SwiftHUEColorPicker] = []
    
    // UserDefauls
    var IP = UserDefaults.standard
    
    
    
    @IBOutlet weak var sendButton: UIButton!
    
    var rgbColor: String = ""
    var parameters : Parameters = [:]
    var isPaused : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        //backgroundImage.bringSubview(toFront: container)

        colorPickers = [verticalColorPicker]
        
        lights = [light0, light3, light5, light6, light7, light8, light11, light12, light13, light15, light18, light19]
        
        
        for colorPicker in colorPickers {
            colorPicker.delegate = self
            colorPicker.direction = SwiftHUEColorPicker.PickerDirection.vertical
            colorPicker.cornerRadius = 50
            colorPicker.labelBackgroundColor = UIColor.white
            colorPicker.labelFontColor = UIColor.clear
        }
        
        verticalColorPicker.type = SwiftHUEColorPicker.PickerType.color

        
        // Remove border from send button
        sendButton.layer.borderWidth = 0.0
        
        
        // Tab Bar delegate
        self.tabBarController?.delegate = self

    }
    
    // Executed when picked color changed
    func valuePicked(_ color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        
        print("NEW color: \(color))")

        starColor = color
        // Change christmas tree color basked on users choice
        christmasTreeIcon.image = christmasTreeIcon.image!.withRenderingMode(.alwaysTemplate)
        christmasTreeIcon.tintColor = color

        sendButton.setTitleColor(color, for: .normal)
        getRGB(color: color)
        
    
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
        // Set changed color to lightes
        for light in self.lights{
            light.image = light.image!.withRenderingMode(.alwaysTemplate)
            light.tintColor = starColor
            
        }
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
    
    func warningClose(gesture: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
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
    
    // UITabBarDelegate
    // TODO: add function to control the tab bar item
/*    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (self.tabBar.items as! [UITabBarItem])[0]{
            //Do something if index is 0
        }
        else if item == (self.tabBar.items as! [UITabBarItem])[1]{
            //Do something if index is 1
        }
    }
    */
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("selected tab bar")
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            print("selected the first tab bar item")
            //do your stuff
        }
    }
    
}








