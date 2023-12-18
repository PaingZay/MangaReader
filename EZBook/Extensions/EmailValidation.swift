//
//  EmailValidation.swift
//  EZBook
//
//  Created by Paing Zay on 12/12/23.


import Foundation

extension
 
String
 
{
    var isValidEmail: Bool {
        let emailRegex =
 
        "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

                
        let emailTest =
         
        NSPredicate(format: "SELF MATCHES %@", emailRegex)
                return emailTest.evaluate(with: self)
    }
}
