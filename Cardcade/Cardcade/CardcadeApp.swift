//
//  CardcadeApp.swift
//  Cardcade
//
//  Created by Jason Leonardo on 17/05/23.
//

import SwiftUI

@main
struct CardcadeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(matchManager: MatchManager())
                .preferredColorScheme(.light)
        }
    }
}
