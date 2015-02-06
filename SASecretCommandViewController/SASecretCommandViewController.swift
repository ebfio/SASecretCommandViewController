//
//  SASecretCommandViewController.swift
//  SASecretCommandViewController
//
//  Created by 鈴木大貴 on 2015/02/07.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

public class SASecretCommandViewController: UIViewController {

    private let commandManager = SASecretCommandManager()
    private var buttonView: SASecreatCommandButtonView!
    private var upGesture: UISwipeGestureRecognizer!
    private var downGesture: UISwipeGestureRecognizer!
    private var leftGesture: UISwipeGestureRecognizer!
    private var rightGesture: UISwipeGestureRecognizer!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.commandManager.delegate = self
        self.addGesture()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addGesture() {
        self.upGesture = UISwipeGestureRecognizer(target: self, action: "detectSwipeGesture:")
        self.upGesture.direction = .Up
        self.view.addGestureRecognizer(self.upGesture)
        
        self.downGesture = UISwipeGestureRecognizer(target: self, action: "detectSwipeGesture:")
        self.downGesture.direction = .Down
        self.view.addGestureRecognizer(self.downGesture)
        
        self.rightGesture = UISwipeGestureRecognizer(target: self, action: "detectSwipeGesture:")
        self.rightGesture.direction = .Right
        self.view.addGestureRecognizer(self.rightGesture)
        
        self.leftGesture = UISwipeGestureRecognizer(target: self, action: "detectSwipeGesture:")
        self.leftGesture.direction = .Left
        self.view.addGestureRecognizer(self.leftGesture)
    }
    
    private func removeGesture() {
        self.view.removeGestureRecognizer(self.upGesture)
        self.view.removeGestureRecognizer(self.downGesture)
        self.view.removeGestureRecognizer(self.leftGesture)
        self.view.removeGestureRecognizer(self.rightGesture)
    }
    
    private func createButtonView() -> SASecreatCommandButtonView {
        let buttonView = SASecreatCommandButtonView(frame: self.view.bounds)
        buttonView.delegate = self
        return buttonView
    }
    
    private func removeButtonView() -> Bool {
        if let buttonView = self.buttonView? {
            buttonView.removeFromSuperview()
            self.addGesture()
            return true
        }
        return false
    }
    
    func detectSwipeGesture(gesture: UISwipeGestureRecognizer) {
        let crossKeyCommand = SASecretCommandType.convert(gesture.direction)
        
        println("\(crossKeyCommand.value())")
        
        self.commandManager.checkCommand(crossKeyCommand)
    }
    
    public func registerSecretCommand(commandList: [SASecretCommandType]) {
        if commandList.count > 0 {
            if let command = commandList.first {
                switch command {
                    case .A, .B:
                        self.buttonView = self.createButtonView()
                        self.removeGesture()
                        self.view.addSubview(self.buttonView)
                    case .Up, .Down, .Left, .Right:
                        break
                }
            }
        }
        
        self.commandManager.secretCommandList = commandList
    }
    
    public func secretCommandPassed() {
        println("command passed")
    }
}

extension SASecretCommandViewController: SASecretCommandManagerDelegate {
    func secretCommandManagerShowButtonView(manager: SASecretCommandManager) {
        if !self.removeButtonView() {
            self.buttonView = self.createButtonView()
        }
        
        self.removeGesture()
        self.view.addSubview(self.buttonView)
    }
    
    func secretCommandManagerCloseButtonView(manager: SASecretCommandManager) {
        self.removeButtonView()
    }
    
    func secretCommandManagerSecretCommandPassed(manager: SASecretCommandManager) {
        self.removeButtonView()
        self.secretCommandPassed()
    }
}

extension SASecretCommandViewController: SASecreatCommandButtonViewDelegate {
    func secretCommandButtonViewAButtonTapped(buttonView: SASecreatCommandButtonView) {
        println("A")
        self.commandManager.checkCommand(.A)
    }
    
    func secretCommandButtonViewBButtonTapped(buttonView: SASecreatCommandButtonView) {
        println("B")
        self.commandManager.checkCommand(.B)
    }
}

protocol SASecreatCommandButtonViewDelegate: class {
    func secretCommandButtonViewAButtonTapped(buttonView: SASecreatCommandButtonView)
    func secretCommandButtonViewBButtonTapped(buttonView: SASecreatCommandButtonView)
}

class SASecreatCommandButtonView: UIView {
    
    private var buttonContainerView: UIView!
    weak var delegate: SASecreatCommandButtonViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        self.buttonContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        self.buttonContainerView.center = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
        self.buttonContainerView.backgroundColor = .redColor()
        self.addSubview(self.buttonContainerView)
        
        let aButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        aButton.setTitle("A", forState: .Normal)
        aButton.addTarget(self, action: "aButtonTapped:", forControlEvents: .TouchUpInside)
        self.buttonContainerView.addSubview(aButton)
        
        let bButton = UIButton(frame: CGRect(x: 100, y: 0, width: 100, height: 100))
        bButton.setTitle("B", forState: .Normal)
        bButton.addTarget(self, action: "bButtonTapped:", forControlEvents: .TouchUpInside)
        self.buttonContainerView.addSubview(bButton)
    }
    
    func aButtonTapped(sender: AnyObject) {
        self.delegate?.secretCommandButtonViewAButtonTapped(self)
    }
    
    func bButtonTapped(sender: AnyObject) {
        self.delegate?.secretCommandButtonViewBButtonTapped(self)
    }
}
