//
//  ViewController.swift
//  StoryTime
//
//  Created by Akito Nozaki on 3/3/18.
//  Copyright © 2018 Ikazone. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import QuartzCore

class ArViewController: StoryTimeViewController<ArViewModel>, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    // A serial queue for thread safety when modifying the SceneKit node graph.
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".serialSceneKitQueue")
    
    var robotNode: SCNNode!
    var robotContainer = SCNNode()
    
    deinit {
        viewModel.onClose()
    }
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let robot = SCNScene(named: "art.scnassets/robot.scn")!
        let container = CAAnimationGroup()
        var animation: CAAnimation! = nil
        
        // Some note about animation here.
        // In most cases, all the animation is merged into a single animation. This means that we need to split the animation into peaces in order to get the desired animation.
        // We can do this by setting offset to the CAAniamtion, then clipping it using CAAnimationGroup.
        
        robotNode = robot.rootNode
        robot.rootNode.enumerateChildNodes({ (child, stop) in
            if child.name == "Root_Bone" {
                if child.animationKeys.count > 0 {
                    animation = child.animation(forKey: child.animationKeys.first!)!
                    container.animations = [animation]
                    child.removeAllAnimations()
                    
                    child.addAnimation(container, forKey: "RobotAnimation")
                }
            }
            
            child.scale = SCNVector3(0.05, 0.05, 0.05)
        })
        robotContainer.addChildNode(robotNode)
        
        container.animation(startFrame: 5100, endFrame: 5200)
        
        // Set the scene to the view
        // sceneView.scene = robot
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resetTracking()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate

/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        
        updateQueue.async { [unowned self] in
            if referenceImage.name == "Robot" {
                self.robotContainer.transform = node.transform
                self.sceneView.scene.rootNode.addChildNode(self.robotContainer)
            }
        }
        
        // session.remove(anchor: imageAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        
        updateQueue.async { [unowned self] in
            if referenceImage.name == "Robot" {
                self.robotContainer.transform = node.transform
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        
        updateQueue.async { [unowned self] in
            if referenceImage.name == "Robot" {
                self.robotContainer.removeFromParentNode()
            }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func resetTracking() {
//        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
//            fatalError("Missing expected asset catalog resources.")
//        }
        
        
        let robotImage = UIImage(named: "Robot")!
//        let size = CGSize(width: robotImage.size.width, height: robotImage.size.height)
//        UIGraphicsBeginImageContext(size)
//        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        robotImage.draw(in: rect, blendMode: .normal, alpha: 1.0)
//        let context = UIGraphicsGetCurrentContext()
//        context?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1)
//        context?.stroke(rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        
        let reference = ARReferenceImage(robotImage.cgImage!, orientation: .up, physicalWidth: 0.065)
        reference.name = "Robot"
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = [reference]
        session.run(configuration)
//
////        statusViewController.scheduleMessage("Look around to detect images", inSeconds: 7.5, messageType: .contentPlacement)
    }
}
