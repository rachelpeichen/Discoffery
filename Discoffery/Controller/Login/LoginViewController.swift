//
//  LoginViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/29.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
  
  // MARK: - Properties
  fileprivate var currentNonce: String?
  
  var userEmail: String?
  
  var userName: String?
  
  var loginViewModel = LoginViewModel()
  
  // MARK: - IBOutlet & IBAction
  @IBOutlet weak var signInWithAppleBtnView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    setupAppleSigninBtn()
    
    observeAppleIDSessionChanges()
    
    loginViewModel.onUserIdentified = {
      
      self.performSegue(withIdentifier: "navigateToMainStoryboard", sender: self)
    }
    
    loginViewModel.onUserCreated = {

      self.performSegue(withIdentifier: "navigateToMainStoryboard", sender: self)
    }
  }

  func showSimpleHUD() {
      let hud = JGProgressHUD()
      hud.vibrancyEnabled = true
      hud.textLabel.text = "Simple example in Swift"
      hud.detailTextLabel.text = "See JGProgressHUD-Tests for more examples"
      hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
      hud.show(in: self.view)
  }
  
  // MARK: - Ask for authorization when btn pressed
  
  func setupAppleSigninBtn() {
    
    let authorizationAppleIDButton: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton()
    
    authorizationAppleIDButton.addTarget(self, action: #selector(pressSignInWithAppleButton), for: UIControl.Event.touchUpInside)
    
    authorizationAppleIDButton.frame = self.signInWithAppleBtnView.bounds
    
    self.signInWithAppleBtnView.addSubview(authorizationAppleIDButton)
  }
  
  @objc func pressSignInWithAppleButton() {
    
    // MARK: - Fire Auth
    let nonce = randomNonceString()
    currentNonce = nonce
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.nonce = sha256(nonce)
    
    let authorizationAppleIDRequest: ASAuthorizationAppleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
    
    authorizationAppleIDRequest.requestedScopes = [.fullName, .email]
    
    let controller: ASAuthorizationController = ASAuthorizationController(authorizationRequests: [authorizationAppleIDRequest])
    
    controller.delegate = self
    
    controller.presentationContextProvider = self
    
    controller.performRequests()
  }
  
  @available(iOS 13, *)
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      return String(format: "%02x", $0)
    }.joined()
    
    return hashString
  }
  
  private func checkCredentialState(withUserID userID: String) {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
      
      switch credentialState {
      
      case .authorized:
        // The user has login
        break
        
      case .revoked:
        // The user has log out
        break
        
      case .notFound:
        // User not found
        break
        
      default:
        break
      }
    }
  }
  
  private func observeAppleIDSessionChanges() {
    
    NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { (notification: Notification) in
      
      // Sign user in or out
      print("Sign user in or out...")
    }
  }
  
  // MARK: - Generate a cryptographically secure
  // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
  private func randomNonceString(length: Int = 32) -> String {
    
    precondition(length > 0)
    
    let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
      
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        return random
      }
      
      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }
        
        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }
    
    return result
  }
}

// MARK: - ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { authResult, error in
        
        if let error = error {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
          print(error.localizedDescription)
          return
          
        } else {
          
          // MARK: - User is signed in to Firebase with Apple.
          guard let firebaseUid = Auth.auth().currentUser?.uid else { return }
          
          guard let user = authResult?.user else { return }
          
          UserManager.shared.user.id = firebaseUid
          UserManager.shared.user.email = user.email ?? "User Email Not Provided"
          UserManager.shared.user.name = user.displayName ?? "User Name Not Provided"

          self.showSuccessHUD(showInfo: "登入成功")

          self.loginViewModel.identifyUser()
        }
      }
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    showErrorHUD(showInfo: "Sign in with Apple error: \(error)")
    print("Sign in with Apple error: \(error)")
  }
  
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  
  // MARK: Present AuthVC
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    
    return self.view.window!
  }
}
