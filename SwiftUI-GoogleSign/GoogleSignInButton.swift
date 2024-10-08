//
//  GoogleSignInButton.swift
//  SwiftUI-GoogleSign
//
//  Created by TeamLeaseRegtech on 08/10/24.
//

import SwiftUI
import GoogleSignIn
import FirebaseCore

struct GoogleSignInButton: UIViewRepresentable {
    var onSignIn: (GIDGoogleUser?) -> Void

    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.addTarget(context.coordinator, action: #selector(Coordinator.signIn), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: GIDSignInButton, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onSignIn: onSignIn)
    }

    class Coordinator: NSObject {
        var onSignIn: (GIDGoogleUser?) -> Void

        init(onSignIn: @escaping (GIDGoogleUser?) -> Void) {
            self.onSignIn = onSignIn
        }

        @objc func signIn() {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let config = GIDConfiguration(clientID: clientID)

            GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                if let error = error {
                    print("Google Sign-In error: \(error.localizedDescription)")
                    return
                }
                self.onSignIn(result?.user)
            }
        }

        private func getRootViewController() -> UIViewController {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                fatalError("No root view controller found")
            }
            return rootViewController
        }
    }
}
