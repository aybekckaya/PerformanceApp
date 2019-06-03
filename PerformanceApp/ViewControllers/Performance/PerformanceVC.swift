//
//  PerformanceVC.swift
//  CADisplayLinkAnimations
//
//  Created by aybek can kaya on 24.05.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import UIKit

class PerformanceVC: UIViewController {

    @IBOutlet weak var lblFramesPerSecond: UILabel!
    @IBOutlet weak var lblTimeDifference: UILabel!
    @IBOutlet weak var lblElapsedTime: UILabel!
    @IBOutlet weak var lblActualFrames: UILabel!
    
    private var latestTimeUpdated:CFTimeInterval = CACurrentMediaTime()
    private var startedTime:CFTimeInterval = CACurrentMediaTime()
    
    private var frameCount:Int = 0
    private var currentIteration:Int = 0
    
    private var displayLink:CADisplayLink!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpDisplayLink()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink.remove(from: .main, forMode: RunLoop.Mode.common)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setUpDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.preferredFramesPerSecond = 60 
        startedTime = CACurrentMediaTime()
        displayLink.add(to: .main, forMode: RunLoop.Mode.common)
    }
    
    @objc private func update() {
        print("refresh : \(CACurrentMediaTime())")
        let actualFramesPerSecond = 1 / (displayLink.targetTimestamp - displayLink.timestamp)
        self.lblActualFrames.text = String(format: "%.03f", actualFramesPerSecond)
    
        let currentTime:CFTimeInterval = CACurrentMediaTime()
        let timeElapsed:Double = currentTime - startedTime
        self.lblElapsedTime.text = String(format: "%.03f", timeElapsed)
        
        let iteration = Int(timeElapsed)
        if currentIteration == iteration {
            frameCount += 1
        }
        else {
            self.lblFramesPerSecond.text = String(describing: frameCount)
            frameCount = 0
            currentIteration = iteration
        }
        
        let timeDiffBetweenUpdates:CFTimeInterval = currentTime - latestTimeUpdated
        self.lblTimeDifference.text = String(format: "%.07f", timeDiffBetweenUpdates)
        
        latestTimeUpdated = currentTime
       
    }
}
