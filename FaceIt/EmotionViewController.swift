//
//  EmotionViewController.swift
//  FaceIt
//
//  Created by Andrea Visini on 21/07/18.
//  Copyright © 2018 Andrea Visini. All rights reserved.
//

import UIKit

class EmotionViewController: UIViewController {

    let emotionalsFaces: Dictionary<String, FacialExpression> = [
        "sad": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Frown),
        "worried": FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Neutral),
        "mischieviouse": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin),
        "happy": FacialExpression(eyes: .Closed, eyeBrows: .Relaxed, mouth: .Smile)
    ]
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVc = segue.destination
        if let navcon = destinationVc as? UINavigationController {
            destinationVc = navcon.visibleViewController ?? destinationVc
        }
        if let faceVc = destinationVc as? FaceViewController {
            if let identifier = segue.identifier {
                if let expression = emotionalsFaces[identifier] {
                    faceVc.expression = expression
                    if let sendingButton = sender as? UIButton {
                        faceVc.navigationItem.title = sendingButton.currentTitle
                    }
                }
            }
        }
    }
}
