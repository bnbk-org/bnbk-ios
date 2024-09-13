//
//  bnbkApp.swift
//  bnbk
//
//  Created by Heryan Djaruma on 17/05/24.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct BnbkApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
