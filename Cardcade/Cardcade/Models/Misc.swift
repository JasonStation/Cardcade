//
//  Misc.swift
//  Cardcade
//
//  Created by Jason Leonardo on 19/05/23.
//

import Foundation

enum PlayerAuthState: String{
    case authenticating = "Logging into Game Center..."
    case unauthenticating = "Please sign in to Game Center to play Cardcade."
    case authenticated = ""
    
    case error = "There was an error logging in to Game Center."
    case restricted = "Multiplayer is restricted."
}
