import FBSDKCoreKit

// Eventually map this so some local persistence store/keychain
struct User {
    static var isLoggedIn: Bool {
        return FBSDKAccessToken.current() != nil
    }
}
