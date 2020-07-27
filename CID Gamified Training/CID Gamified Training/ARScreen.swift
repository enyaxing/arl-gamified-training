//
//  ContentView.swift
//  ARApp
//
//  Created by Alex on 6/12/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import RealityKit
import ARKit
import SceneKit

struct ARScreen : View {
    
    @State var modelLoad: String?
    @State var currModel: AnchorEntity?
    @State var arMode = true
    @State var scene = SCNScene()
    
    var vehicleName: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if self.arMode {
                ARViewContainer(modelLoad: self.$modelLoad, currModel: self.$currModel).edgesIgnoringSafeArea(.all)
            } else {
                SceneKitView(scene: self.$scene)
            }
            HStack {
                Spacer()
                Button(action: {
                    print("place")
                    if let anchor = self.currModel {
                        anchor.removeFromParent()
                    }
                    self.modelLoad = "\(self.vehicleName).usdz"
                    self.scene = SCNScene(named: "\(self.vehicleName).usdz")!
                }) {
                    Text("Place")
                        .font(.largeTitle)
                }
                Spacer()
                
                Text("AR")
                    .font(.largeTitle)
                    .foregroundColor(Color.blue)
                Toggle("AR", isOn: $arMode).labelsHidden()
                Spacer()
            }
        }
    }
}

struct SceneKitView : UIViewRepresentable {
    
    @Binding var scene: SCNScene
    
    func makeUIView(context: Context) -> SCNView {
            
        // retrieve the SCNView
        let scnView = SCNView()
        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 50)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 25, z: 0)
        scene.rootNode.addChildNode(lightNode)

        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        scnView.scene = scene

        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true

        // show statistics such as fps and timing information
        scnView.showsStatistics = false

        // configure the view
        scnView.backgroundColor = UIColor.white
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var modelLoad: String?
    @Binding var currModel: AnchorEntity?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        arView.session.run(config)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let modelName = self.modelLoad {
            
            print("Adding model to scene - \(modelName)")
            
            let modelEntity = try! ModelEntity.loadModel(named: modelName)
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(modelEntity)
            uiView.scene.addAnchor(anchorEntity)
            
            modelEntity.generateCollisionShapes(recursive: true)
            uiView.installGestures([.translation, .rotation, .scale], for: modelEntity)
            
            DispatchQueue.main.async {
                self.modelLoad = nil
                self.currModel = anchorEntity
            }
        }
    }
}
