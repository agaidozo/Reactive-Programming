//
//  ViewController.swift
//  Reactive Programming
//
//  Created by Obde Willy on 09/01/23.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let viewModel = LoginViewModel()  // 1
    let disposeBag = DisposeBag()  // 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.rx.text.orEmpty.bind(to: viewModel.email)
        .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password)
        .disposed(by: disposeBag)
        
        viewModel.isValid.map { $0 }
        .bind(to: loginButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Login", message: "Login Button Enabled/Tapped!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//1
struct LoginViewModel {
//    2
    let email = BehaviorRelay<String>(value: "")
//    3
    let password = BehaviorRelay<String>(value: "")
//    4
    let isValid: Observable<Bool>
    
    init() {
//        5
        isValid = Observable.combineLatest(self.email.asObservable(), self.password.asObservable())
        { (email, password) in
//            6
            return email.isValidEmail()
                && password.isValidPassword()
        }
    }
}

extension String {
    /// Used to validate if the given string is valid email or not
    ///
    /// - Returns: Boolean indicating if the string is valid email or not
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print("emailTest.evaluate(with: self): \(emailTest.evaluate(with: self))")
        return emailTest.evaluate(with: self)
    }
    
    /// Used to validate if the given string matches the password requirements
    ///
    /// - Returns: Boolean indicating the comparison result
    func isValidPassword() -> Bool {
        print("self.count >= 6: \(self.count >= 6)")
        return self.count >= 6
    }
}
