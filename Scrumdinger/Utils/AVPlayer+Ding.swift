//
//  AVPlayer+Ding.swift
//  Scrumdinger
//
//  Created by Mitul Vaghamshi on 2022-10-13.
//

import Foundation
import AVFoundation

extension AVPlayer {
    static let sharedDingPlayer: AVPlayer = {
        guard let url = Bundle.main
            .url(forResource: "ding", withExtension: "wav")
        else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
}
