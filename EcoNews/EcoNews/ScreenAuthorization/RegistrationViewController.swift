//
//  SignUpControllerView.swift
//  EcoNews
//
//  Created by Ткаченко Никита on 07.11.2020.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var btnPickPhoto: UIButton!
    @IBOutlet weak var buttonForSign: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
    }
    
    func assignbackground(){
        let imageView = OperationsWithView.changeImageView(nameBackground: "signUp.png", view: view)
        self.view.sendSubviewToBack(imageView)
        self.buttonForSign.layer.cornerRadius = 3
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        let image = UIImage(named: "defaultPhoto")
        userImage.image = image
    }
    
    @IBAction func exitButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pickPhoto(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func upload(currentUserId: String,photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void){
        let ref = Storage.storage().reference().child("avatars").child(currentUserId)
        guard let imageData = userImage.image?.jpegData(compressionQuality: 0.4) else {
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        ref.putData(imageData, metadata: metadata, completion: {(metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL(completion: { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            })
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first) != nil{
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }

    @IBAction func signUpButton(_ sender: Any) {
        let error = checkIncorrectData()
        if error == nil {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (resultFirst, error) in
                if error != nil {
                    self.errorLabel.text = "error of signUp"
                } else {
                    guard let result = resultFirst else {
                        return
                    }
                    self.upload(currentUserId: result.user.uid, photo: self.userImage.image!) { (result) in
                        switch result {
                        case .success(let url):
                            self.initUser(userUid: (resultFirst?.user.uid)!, url: url)
                            OperationsUserDef.setInDefaults(firstName: self.firstNameTextField.text!, secName: self.secondNameTextField.text!, email: self.emailTextField.text!, uidUser: (resultFirst?.user.uid)!)
                            self.present(OperationsWithController.initVC(nameVC: "TabBar", identifier: "TabBarID"), animated: true, completion: nil)
                        case .failure(_):
                            print("error")
                        }
                    }
                    
                }
            }
        } else{
            self.errorLabel.text = error
        }
    }
    func checkIncorrectData()->String?{
        if firstNameTextField.text == "" ||
            secondNameTextField.text == "" ||
            emailTextField.text == "" ||
            passwordTextField.text == "" ||
            firstNameTextField.text == nil ||
            secondNameTextField.text == nil ||
            emailTextField.text == nil ||
            passwordTextField.text == nil {
            return "Please fill in all fields"
        }
        return nil
    }
    
    func initUser(userUid: String, url: URL){
        let db = Firestore.firestore()
        db.collection("ecoUsers").document(userUid).setData([
            "firstName": self.firstNameTextField.text!,
            "secondName": self.secondNameTextField.text!,
            "email": self.emailTextField.text!,
            "avatarURL": url.absoluteString,
            "password": self.passwordTextField.text!,
            "rating": 0
        ]){ (error) in
            if error != nil {
                self.errorLabel.text = "Error saving user in database"
            }
        }
    }
}
extension RegistrationViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        userImage.image = image
    }
}
