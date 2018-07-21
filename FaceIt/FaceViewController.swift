//
//  ViewController.swift
//  FaceIt
//
//  Created by Andrea Visini on 15/07/18.
//  Copyright © 2018 Andrea Visini. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Neutral) {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(FaceView.changeScale(_:))
            ))
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.increaseHappiness)
            )
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let saddierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.decreaseHappiness)
            )
            saddierSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(saddierSwipeGestureRecognizer)
            
            faceView.addGestureRecognizer(UITapGestureRecognizer(
                target: self, action: #selector(FaceViewController.toggleEyes)
            ))
            updateUI()
        }
    }
    
    @objc func toggleEyes(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
        
    }
    
    
    @IBAction func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    @IBAction func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    private var mouthCurvatures = [
        FacialExpression.Mouth.Frown : -1.0,
        FacialExpression.Mouth.Smirk : -0.5,
        FacialExpression.Mouth.Neutral : 0.0,
        FacialExpression.Mouth.Grin : 0.5,
        FacialExpression.Mouth.Smile : 1.0,
        ]
    
    private var eyeBrowTilt = [
        FacialExpression.EyeBrows.Normal : 0.0,
        FacialExpression.EyeBrows.Furrowed : -1.0,
        FacialExpression.EyeBrows.Relaxed : 0.5
    ]
    
    private func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .Open: faceView.eyeOpen = true
            case .Closed: faceView.eyeOpen = false
            case .Squinting: faceView.eyeOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilt[expression.eyeBrows] ?? 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

