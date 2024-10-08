//
//  ContentView.swift
//  SwiftUI-GoogleSign
//
//  Created by TeamLeaseRegtech on 08/10/24.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

struct ContentView: View {
    @State private var isSignedIn = false
    
    var body: some View {
        VStack {
            if isSignedIn {
                Text("You're signed in!")
                Button(action: {
                    handleSignOut()
                }) {
                    Text("Sign Out")
                        .frame(width: 200, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                VStack{
                    Image("login")
                        .resizable()
                        .frame(width: 400,height: 400)
                        .padding(.bottom,10)
                    GoogleSignInButton { user in
                        guard let user = user else {
                                      print("Google Sign-In user data is missing")
                                       return
                                   }
                                   let idToken = user.idToken?.tokenString ?? ""
                                   let accessToken = user.accessToken.tokenString

                        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

                        Auth.auth().signIn(with: credential) { authResult, error in
                            if let error = error {
                                print("Firebase sign-in failed: \(error.localizedDescription)")
                            } else {
                                print("User signed in to Firebase successfully")
                                isSignedIn = true
                            }
                        }
                    }
                    .frame(width: 300, height: 60)
                    .padding(.top,10)
                }
            }
        }
        .padding()
    }

    func handleSignOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            isSignedIn = false
            print("User signed out successfully")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError.localizedDescription)
        }
    }

    func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return nil
        }
        return rootViewController
    }
}

#Preview {
    ContentView()
}






//import SwiftUI
//import GoogleSignIn
//import FirebaseAuth
//import FirebaseCore
//
//struct ContentView: View {
//    @State private var isSignedIn = false
//    
//    var body: some View {
//        VStack {
//            if isSignedIn {
//                Text("You're signed in!")
//                Button(action: {
//                    handleSignOut()
//                }) {
//                    Text("Sign Out")
//                        .frame(width: 200, height: 50)
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//            } else {
//                Button(action: {
//                    handleSignIn()
//                }) {
//                    
//                    HStack{
//                        Image("")
//                        Text("GoogleSignIn")
//                            .frame(width: 200, height: 50)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                }
//            }
//        }
//        .padding()
//    }
//
//    func handleSignIn() {
//        // Ensure Firebase is properly configured
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        // Initialize Google sign-in configuration
//        let config = GIDConfiguration(clientID: clientID)
//
//        // Get the root view controller for presenting the sign-in UI
//        guard let rootViewController = getRootViewController() else {
//            print("No root view controller found")
//            return
//        }
//
//        // Initiate the Google Sign-In process
//        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
//            if let error = error {
//                print("Google Sign-In error: \(error.localizedDescription)")
//                return
//            }
//
//            // Ensure authentication data is available
//            guard let user = result?.user else {
//                print("Google Sign-In user data is missing")
//                return
//            }
//
//            // Unwrap the ID token and access token
//            let idToken = user.idToken?.tokenString ?? "" // Assign empty string if nil
//            let accessToken = user.accessToken.tokenString // Directly access since it's non-optional
//
//            // Create Google credentials for Firebase authentication
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
//
//            // Sign in to Firebase with the Google credentials
//            Auth.auth().signIn(with: credential) { authResult, error in
//                if let error = error {
//                    print("Firebase sign-in failed: \(error.localizedDescription)")
//                } else {
//                    print("User signed in to Firebase successfully")
//                    isSignedIn = true
//                }
//            }
//        }
//    }
//
//    func handleSignOut() {
//        do {
//            // Sign out from Firebase
//            try Auth.auth().signOut()
//
//            // Sign out from Google
//            GIDSignIn.sharedInstance.signOut()
//
//            // Update the sign-in state
//            isSignedIn = false
//            print("User signed out successfully")
//        } catch let signOutError as NSError {
//            print("Error signing out: %@", signOutError.localizedDescription)
//        }
//    }
//
//    // Helper to get the root view controller for presenting the UI
//    func getRootViewController() -> UIViewController? {
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let rootViewController = windowScene.windows.first?.rootViewController else {
//            return nil
//        }
//        return rootViewController
//    }
//}
//
//#Preview {
//    ContentView()
//}
