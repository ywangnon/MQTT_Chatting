//
//  ViewController.swift
//  MQTTChattingSample
//
//  Created by Hansub Yoo on 2020/04/18.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//

import UIKit
import SnapKit
import MQTTClient

class ViewController: UIViewController {
    var hostTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        textField.placeholder = "host 주소를 입력하세요."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var topicTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 5
        textField.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        textField.placeholder = "연결할 topic을 입력하세요."
        textField.text = "iOSMQTTTest"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var idTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 5
        textField.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        textField.placeholder = "ID를 입력하세요."
        textField.text = "iOSMQTTTest"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = .blue
        button.setTitle("로그인", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - mqtt Setting
    private var transport = MQTTCFSocketTransport()
    private var session = MQTTSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setViewFoundation()
        self.setAddSubViews()
        self.setLayouts()
    }
    
    func setViewFoundation() {
        
    }
    
    func setAddSubViews() {
        self.view.addSubview(self.hostTextField)
        self.view.addSubview(self.topicTextField)
        self.view.addSubview(self.idTextField)
        self.view.addSubview(self.loginButton)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.hostTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
            make.height.equalTo(48)
            make.bottom.equalTo(self.topicTextField.snp.top).offset(-24)
        }
        
        self.topicTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
            make.height.equalTo(48)
            make.bottom.equalTo(self.idTextField.snp.top).offset(-24)
        }
        
        self.idTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
            make.height.equalTo(48)
            make.bottom.equalTo(safeArea.snp.centerY)
        }
        
        self.loginButton.snp.makeConstraints { (make) in
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
            make.height.equalTo(48)
            make.top.equalTo(self.idTextField.snp.bottom).offset(24)
        }
    }
    
    func setDelegates() {
        self.hostTextField.delegate = self
        self.topicTextField.delegate = self
        self.idTextField.delegate  = self
    }
    
    func setAddTargets() {
        self.loginButton.addTarget(self, action: #selector(loginButton(_:)), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ViewController {
    
}

extension ViewController {
    @objc func loginButton(_ sender: UIButton) {
        // mosquitto 연결
        guard let host = self.hostTextField.text else {
            return
        }
        
        // 개인적으로는 어차피 테스트인거 그냥 세팅하고 연결하고 싶지만, 다른 사람이
        self.transport.host = host
        self.transport.port = 1883
        
        self.session?.transport = self.transport
        
        if let topic = self.topicTextField.text,
            let id = self.idTextField.text {
            self.session?.connect(connectHandler: { (error) in
                if error != nil {
                    print("Connection Error: ", error?.localizedDescription)
                    print("Session Status: ", self.session?.status)
                    
                } else {
                    print("Session Status: ", self.session?.status)
                    
                    
                }
            })
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
}
