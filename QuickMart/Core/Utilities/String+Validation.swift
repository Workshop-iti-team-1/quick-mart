//
//  String+Validation.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        // At least 6 characters for now
        return self.count >= 6
    }
}
