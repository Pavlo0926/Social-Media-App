//
//  PlayerView.swift
//  VideoChatApp
//
//  Created by Apple on 12/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class PlayerView : UIView {
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer : AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player : AVPlayer {
        get {
            return playerLayer.player!
        }
        
        set {
            playerLayer.player = newValue
        }
    }
}
