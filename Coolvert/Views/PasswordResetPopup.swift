//
//  PasswordResetPopup.swift
//  Coolvert
//
//  Created by Alysson Reis on 11/06/2024.
//
import UIKit
import SwiftUI
import Firebase

struct PasswordResetPopup: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var email: String
    @Binding var errorMessage: String
    var viewModel: AuthenticationViewModel
    
    
    func makeUIViewController(context: Context) -> UIViewController {
        let alert = UIAlertController(title: "Recuperar Senha", message: "Insira seu e-mail para recuperar sua senha", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "E-mail"
            textField.text = self.email
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            self.isPresented = false
        })
        
        alert.addAction(UIAlertAction(title: "Enviar", style: .default) { _ in
            if let textField = alert.textFields?.first, let email = textField.text {
                self.email = email
                self.viewModel.sendPasswordReset()
            }
        })

        return alert
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}



