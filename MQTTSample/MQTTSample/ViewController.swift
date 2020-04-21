//
//  ViewController.swift
//  MQTTSample
//
//  Created by Hansub Yoo on 2020/04/21.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//

import UIKit
import SnapKit
import MQTTClient

class ViewController: UIViewController {
    var connectView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.register(OtherCell.self, forCellReuseIdentifier: "otherCell")
        tableView.register(MyCell.self, forCellReuseIdentifier: "myCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var hostTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 10
        textField.placeholder = "host 주소를 입력하세요."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var messageTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 10
        textField.placeholder = "메세지를 입력하세요."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    var connectButton: UIButton = {
        let button = UIButton()
        button.setTitle("연결", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var disConnectButton: UIButton = {
        let button = UIButton()
        button.setTitle("연결 해제", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var transport = MQTTCFSocketTransport()
    private var session = MQTTSession()
    
    private let id = UIDevice.current.identifierForVendor?.uuidString
    private let topic = "iOSMQTTSample"
    
    private var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewFoundations()
        self.setAddSubViews()
        self.setLayouts()
        self.setDelegates()
        self.setAddTargets()
        self.setGestures()
    }
    
    func setViewFoundations() {
        self.connectView.backgroundColor = .red
    }
    
    func setAddSubViews() {
        let views = [
            self.connectView,
            self.chatTableView,
            self.hostTextField,
            self.messageTextField,
            self.connectButton,
            self.disConnectButton
        ]
        
        for subView in views {
            self.view.addSubview(subView)
        }
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.connectView.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.centerX.equalTo(safeArea.snp.centerX)
            make.top.equalTo(safeArea.snp.top).offset(8)
        }
        
        self.chatTableView.snp.makeConstraints { (make) in
            make.leading.equalTo(safeArea.snp.leading)
            make.trailing.equalTo(safeArea.snp.trailing)
            make.top.equalTo(self.connectView.snp.bottom).offset(8)
            make.bottom.equalTo(safeArea.snp.centerY)
        }
        
        self.hostTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(safeArea.snp.leading).offset(8)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-8)
            make.top.equalTo(self.chatTableView.snp.bottom).offset(8)
            make.height.equalTo(32)
        }
        
        self.messageTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(safeArea.snp.leading).offset(8)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-8)
            make.top.equalTo(self.hostTextField.snp.bottom).offset(8)
            make.height.equalTo(32)
        }
        
        self.connectButton.snp.makeConstraints { (make) in
            make.leading.equalTo(safeArea.snp.leading)
            make.trailing.equalTo(self.disConnectButton.snp.leading)
            make.height.equalTo(40)
            make.top.equalTo(self.hostTextField.snp.bottom).offset(8)
        }
        
        self.disConnectButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.connectButton.snp.width)
            make.top.equalTo(self.connectButton.snp.top)
            make.bottom.equalTo(self.disConnectButton.snp.bottom)
            make.trailing.equalTo(safeArea.snp.trailing).offset(8)
        }
    }
    
    func setDelegates() {
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        
        self.messageTextField.delegate = self
    }
    
    func setAddTargets() {
        self.connectButton.addTarget(self, action: #selector(connect(_:)), for: .touchUpInside)
        self.disConnectButton.addTarget(self, action: #selector(disconnect(_:)), for: .touchUpInside)
    }
    
    func setGestures() {
        
    }
}

// 버튼 액션 모음
extension ViewController {
    @objc func connect(_ sender: UIButton) {
        guard let host = self.hostTextField.text else {
            self.showAlert(controller: self, title: "오류", message: "주소를 입력해주세요.", alertStyle: .alert)
            return
        }
        
        self.transport.host = host
        self.transport.port = 1883
        
        self.session?.transport = transport
        
        self.session?.connect(connectHandler: { (error) in
            if error != nil {
                self.showAlert(controller: self, title: "오류", message: error!.localizedDescription, alertStyle: .alert)
            } else {
                self.connectView.backgroundColor = .green
                
                self.session?.delegate = self
                // 구독
                self.session?.subscribe(toTopic: self.topic, at: .exactlyOnce, subscribeHandler: { (error, gQoss) in
                    if error != nil {
                        self.showAlert(controller: self, title: "오류", message: error!.localizedDescription, alertStyle: .alert)
                    } else {
                        print("Subcription Successfull! Granted Qos: ", gQoss)
                    }
                })
            }
        })
    }
    
    @objc func disconnect(_ sender: UIButton) {
        self.session?.close(disconnectHandler: { (error) in
            if error != nil {
                self.showAlert(controller: self, title: "오류", message: error!.localizedDescription, alertStyle: .alert)
            } else {
                self.connectView.backgroundColor = .red
            }
        })
    }
}

// 함수
extension ViewController {
    func showAlert(controller: UIViewController, title: String, message : String, alertStyle: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        let alertAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        controller.present(alert, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let message = self.messageTextField.text,
            let id = self.id {
            self.messageTextField.text = nil
            
            session?.publishData("\(message)@\(id)" .data(using: .utf8, allowLossyConversion: false), onTopic: self.topic, retain: false, qos: .exactlyOnce, publishHandler: { (error) in
                if error != nil {
                    print("Sending message Error: ", error!.localizedDescription)
                } else {
                    print("Message sent!!!!")
                }
            })
        }
        return true
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.messages[indexPath.row].isSender {
            let messageCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            return messageCell
        } else {
            let messageCell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath)
            return messageCell
        }
    }
}

extension ViewController: MQTTSessionDelegate {
    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        print("New Message ID::: ", mid)
        
        if let newMessage = String(bytes: data, encoding: .utf8) {
            if let messageBody = newMessage.components(separatedBy: "@").first,
                let userID = newMessage.components(separatedBy: "@").last {
                if let id = self.id {
                    let message = Message(id: mid, message: messageBody, isSender: userID == id, date: Date())
                    self.messages.append(message)
                }
            }
        }
    }
}
