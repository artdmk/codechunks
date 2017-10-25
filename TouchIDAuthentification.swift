//
//  TouchIDAuthentification.swift
//  codechunks
//
//  Created by Demchenko Artem on 7/11/17.
//  Copyright © 2017 artdmk. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDAuthentification {
    
    let context = LAContext()
    
    typealias SuccessHandler = (Bool, Error?) -> ()
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authenticateUser(completion: @escaping SuccessHandler) {
        
        guard canEvaluatePolicy() else {
            completion(false, LAError.touchIDNotAvailable as? Error)
            return
        }
        var myLocalizedReasonString = "Sign in with Touch ID"
        if #available(iOS 11, *) {
            switch context.biometryType {
            case .typeFaceID:
                myLocalizedReasonString = "Sign in with Face ID"
            default:
                break
            }
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: myLocalizedReasonString.localized) {
                                (success, evaluateError) in
                                var params: (sucess: Bool, error: Error?)
                                if success {
                                    params = (true, nil)
                                } else {
                                    switch evaluateError {
                                    case LAError.userFallback?, LAError.userCancel?:
                                        params = (false, nil)
                                    default:
                                        params = (false, evaluateError)
                                    }
                                }
                                DispatchQueue.main.async {
                                    // User authenticated successfully, take appropriate action
                                    completion(params.sucess, params.error)
                                }
        }
    }
}

extension LAError.Code {
    public var localizedDescription: String {
        let message: String
        switch self {
        case .authenticationFailed:
            message = "There was a problem verifying your identity."
        case .userCancel:
            message = "You pressed cancel."
        case .userFallback:
            message = "You pressed password."
        default:
            message = "Biometrical ID may not be configured"
        }
        return message
    }
}
