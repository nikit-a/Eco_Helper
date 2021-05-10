//
//  AuthorizationViewController.swift
//  EcoNews
//
//  Created by Ткаченко Никита on 07.11.2020.
//

import UIKit
import Firebase
import FirebaseStorage
class AuthorizationViewController: UIViewController {
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var labelForError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = OperationsWithView.changeImageView(nameBackground: "signIn.png", view: view)
        self.view.sendSubviewToBack(imageView)
    }
    
    func checkValidData()->String? {
        if loginTextField.text == nil ||
            loginTextField.text == "" ||
            passwordTextField.text == nil ||
            passwordTextField.text == ""{
            return "Please fill in all fiels"
        }
        return nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil{
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func exitButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonInput(_ sender: Any) {
        let myerror = checkValidData()
        if myerror == nil{
            Auth.auth().signIn(withEmail: loginTextField.text!, password: passwordTextField.text!) { (result, error) in
                if error != nil {
                    self.labelForError.alpha = 1
                    self.labelForError.text = "User is not found"
                } else {
                    self.getUserFieldsAndPushToDefaults(uidUser: (result?.user.uid)!)
                    self.present(OperationsWithController.initVC(nameVC: "TabBar", identifier: "TabBarID"), animated: true, completion: nil)
                }
            }
        }
        else{
            self.labelForError.alpha = 1
            self.labelForError.text = myerror
        }
    }
    
    func getUserFieldsAndPushToDefaults(uidUser: String){
        let db = Firestore.firestore()
        let docRef = db.collection("ecoUsers").document(uidUser)
        docRef.getDocument(source: .default) { (document, error) in
            if let document = document {
                let secName = (document.get("secondName") as! String)
                let firstName = (document.get("firstName") as! String)
                let email = self.loginTextField.text!
                OperationsUserDef.setInDefaults(firstName: firstName, secName: secName, email: email, uidUser: uidUser)
            }
        }
    }
}
