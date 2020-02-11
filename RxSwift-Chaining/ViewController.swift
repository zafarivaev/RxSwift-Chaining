//
//  ViewController.swift
//  RxSwift-Chaining
//
//  Created by Zafar on 1/31/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindTextField()
    }
    
    private func animateTextField() -> Observable<Bool> {
        return Observable.create { observer -> Disposable in
            
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.textField.backgroundColor = .systemGreen
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.textField.backgroundColor = .white
                self.textField.text = ""
                observer.onNext(true)
            }
        })
            return Disposables.create()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type here..."
        textField
            .translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        return textField
    }()


}

// MARK: - Binding
extension ViewController {
    private func bindTextField() {
        textField.rx.text
            .orEmpty
            .filter { $0.count == 5 }
            .flatMap { self.findSubstring(in: $0) }
            .filter { $0 == true }
            .flatMap { _ in self.animateTextField() }
            .filter { $0 == true }
            .subscribe(onNext: { _ in
                print("Subscribed")
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Observables
extension ViewController {
    private func findSubstring(in string: String) -> Observable<Bool> {
        return Observable.create { observer -> Disposable in
            
            if string.lowercased().contains("rx") {
                observer.onNext(true)
            } else {
                observer.onNext(false)
            }
         
            return Disposables.create()
        }
    }
}

extension ViewController {
    private func setupUI() {
        overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .white
        self.view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.heightAnchor
                .constraint(equalToConstant: 50),
            textField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50),
            textField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50)
            
        ])
    }
}
