//
//  LoginVC.swift
//  Mobe
//
//  Created by user on 28/02/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin
import GoogleSignIn


class LoginVC: UIViewController,FBSDKLoginButtonDelegate,GIDSignInDelegate,GIDSignInUIDelegate {
    let getPostValueForFacebook = [Any]()
    var postDataDictionary = ["NAME":"","EMAIL":"","USER_ID":""]
    var patternsDict =  [String : String]()
    var arrayValue = [String]()
    var outletId:String?
    var fullName:String?
    var facebookProfileID:String?
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        getFBUserData()
       
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
         print("logout")
       
    }
    

    @IBOutlet weak var btnFacebookLogin: FBSDKLoginButton!
    var userData: UserLogin?
    
    
    //Google sign in
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let image = user.profile.imageURL(withDimension: 120)
            print(userId ?? "no value","\n",idToken ?? "no value","\n",fullName ?? "no value","\n",givenName ?? "no value","\n",familyName ?? "no value","\n",familyName ?? "no value","\n",email ?? "no value","\n",image ?? "no value" )
            if let image = image{
                
                 userData = UserLogin(name: fullName ?? "nil", urlPath: image, mailId: email ?? "nil")
                
                performSegue(withIdentifier: "showOutlets", sender: (Any).self)
                
              }
        }
    }
    func PostData(){
        
        guard let credentialsUrl = URL(string: "https://evening-chamber-14219.herokuapp.com/users/createUser") else{ return}
        var request = URLRequest(url: credentialsUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // guard let httpBody = try? JSONSerialization.data(withJSONObject: patternsDict, options: [])else{return}
        let httpBody = try? JSONSerialization.data(withJSONObject: postDataDictionary)
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request){(data,response,error)in
            if let response = response{
                print("response",response)
            }
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    let facebookProfile = URL(string: "http://graph.facebook.com/\(self.facebookProfileID)/picture?type=large")
                    if let image = facebookProfile{
                        
                        self.userData = UserLogin(name: self.fullName ?? "nil", urlPath: image, mailId: "")
                        
                        self.performSegue(withIdentifier: "showOutlets", sender: (Any).self)
                    }
                }catch{
                    print("",error)
                }
                
            }
            }.resume()
        
    }
  
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "showOutlets" {
                if let destinationVC = segue.destination as? UINavigationController {
                    if let VC = destinationVC.viewControllers.first as? BarLoaction{
                    VC.userInfo = userData
                    }
                }
            }
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
    GIDSignIn.sharedInstance().clientID="899581382227-997dbo5s7rutf1otuivdvjvoe1d6nvn8.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().uiDelegate = self
        btnFacebookLogin.readPermissions = ["email"]
        btnFacebookLogin.delegate = self
       /* if let accessToken = FBSDKAccessToken.current(){
            print("accessToken fb ",accessToken)
            
            getFBUserData()
        }*/
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        // loginManager.lo([ .publicProfile], viewController: self) { loginResult in
        loginManager.logIn(readPermissions: [ .publicProfile,.email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email, id"]).start(completionHandler:
                { (connection, result, error) -> Void in
                    
                    if (error == nil)
                    {
                        //everything works print the user data
                        if let data = result as? NSDictionary
                        {
                            print("data",data)
                            for(key,value) in data{
                                self.arrayValue.append(value as! String)
                            }
                            self.postDataDictionary.updateValue(self.arrayValue[0] , forKey: "NAME")
                            self.postDataDictionary.updateValue(self.arrayValue[1] , forKey: "EMAIL")
                            self.postDataDictionary.updateValue(self.arrayValue[2] , forKey: "USER_ID")
                            self.postDataDictionary.updateValue("USER" , forKey: "USER_TYPE")
                            self.postDataDictionary.updateValue("F" , forKey: "SOURCE")
                            self.facebookProfileID = self.postDataDictionary["USER_ID"]
                            
                            self.fullName = data.object(forKey: "name") as? String
                            let facebookProfile = URL(string: "http://graph.facebook.com/\(self.facebookProfileID)/picture?type=large")
                            if let image = facebookProfile{
                                
                                self.userData = UserLogin(name: self.fullName ?? "nil", urlPath: image, mailId: "")
                                
                                self.performSegue(withIdentifier: "showOutlets", sender: (Any).self)
                            }
                            else
                            {
                                // If user have signup with mobile number you are not able to get their email address
                                print("We are unable to access Facebook account details, please use other sign in methods.")
                            }
                            
                        }
                    }
            })
             
        }
       
    }
    
}

