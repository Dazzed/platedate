////
////  APIClient.swift
////  PlateDate
////
////  Created by WebCrafters on 03/12/18.
////  Copyright © 2018 WebCrafters. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//import Alamofire
//import FBSDKLoginKit
//
//class APIClient:UIViewController {
//
//    // MARK: - APIClient Declaration
//    static let shared = APIClient()
//
//    // --------------------------------------------------- AUTHENTICATION ---------------------------------------------------
//
//    // MARK: - Email Login
//    func emailLogin(email:String, completion: @escaping (Bool, Error?) ->Void) {
//        let url = API.Users.emailPath
//        let parameter: Parameters = [API.emailLloginFields.email:email]
//        AlamofireManagaer.request(url, method: .post, parameters: parameter, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
//            let validation = self.validate(response)
//            print(validation)
//            print(response)
//            if validation.status != true {
//                return completion (false, validation.error)
//            }
//             completion(true,nil)
//        }
//    }
//
//    // MARK: - Email Verify
//    func emailVerify(email:String, verificationCode:String, completion: @escaping (Bool, Error?) ->Void) {
//        let url = API.Users.emailVerifyPath
//        let parameter: Parameters = [API.eamilVerifyFields.email:email, API.eamilVerifyFields.verificationCode:verificationCode]
//        AlamofireManagaer.request(url, method: .post, parameters: parameter, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
//            let validation = self.validate(response)
//            print(validation.dict)
//            guard validation.status, let dict: [String:Any] = validation.dict else {
//                return completion (false, validation.error)
//            }
//            print(dict)
//            AuthenticationInfo.emailVerifyData(dict)
//             completion(true,nil)
//        }
//    }
//
//    // MARK: - Mobile Login
//    func mobileLogin(mobile:String, completion: @escaping (Bool, Error?) ->Void) {
//        let url = API.Users.mobilePath
//        let parameter: Parameters = [API.mobileLoginFields.mobile:mobile]
//        AlamofireManagaer.request(url, method: .post, parameters: parameter, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
//            let validation = self.validate(response)
//            guard validation.status, let dict: [String:Any] = validation.dict else {
//                return completion (false, validation.error)
//            }
//            AuthenticationInfo.retriveMobileLogin(dict)
//             completion(true,nil)
//        }
//    }
//
//    // MARK: - Mobile OTP Verify
//    func otpVerify(mobile:String, otp:Double, completion: @escaping (Bool, Error?) ->Void) {
//       let url = API.Users.otpPath
//       let parameter: Parameters = [API.otpVerifyFields.mobile:mobile, API.otpVerifyFields.otp:otp]
//        AlamofireManagaer.request(url, method: .post, parameters: parameter, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
//            let validation = self.validate(response)
//            guard validation.status, let dict: [String:Any] = validation.dict else {
//                return completion (false, validation.error)
//            }
//            print(dict)
//            AuthenticationInfo.retriveOTPVerify(dict)
//             completion(true,nil)
//        }
//    }
//
//     // MARK: - Facebook SignUp
//    func faceBookUser(completion: @escaping  (Bool,Error?) -> Void) {
//        let url = API.Users.facebookPath
//        let parameter:Parameters =  [API.faceBookFields.email: User.Facebook.email, API.faceBookFields.authToken:User.Facebook.authToken ]
//        AlamofireManagaer.request(url, method: HTTPMethod.post, parameters:parameter, encoding:URLEncoding.default) { (response) -> Void in
//            let validation = self.validate(response)
//            print(response)
//            guard validation.status, let dict: [String:Any] = validation.dict else {
//                return completion (false, validation.error)
//            }
//                print(dict)
//            AuthenticationInfo.faceBookData(dict)
//            completion(true,nil)
//        }
//    }
//
//
//
//    // --------------------------------------------------- AUTHENTICATION ---------------------------------------------------
//
//    // --------------------------------------------------- PROFILE ---------------------------------------------------
//
//    // MARK: - profileInfo
//   func profileInfo(id:Double, profileName:String, userName:String, dietaryRestrictions:Double, allergies:String, completion: @escaping  (Bool,Error?) -> Void) {
//        let url = API.Users.profileInfoPath
//        let parameter:Parameters =  [API.profileInfoFields.id: id, API.profileInfoFields.profileName:profileName, API.profileInfoFields.userName: userName, API.profileInfoFields.dietaryRestrictions:dietaryRestrictions, API.profileInfoFields.allergies:allergies]
//        AlamofireManagaer.request(url, method: HTTPMethod.post, parameters:parameter, encoding:URLEncoding.default) { (response) -> Void in
//            let validation = self.validate(response)
//            print(response)
//            guard validation.status, let dict: [String:Any] = validation.dict else {
//                return completion (false, validation.error)
//            }
//                print(dict)
//           // AuthenticationInfo.faceBookData(dict)
//            completion(true,nil)
//        }
//    }
//
//    // --------------------------------------------------- PROFILE ---------------------------------------------------
//
//    // MARK: - AddRecipe
//
//    func json(from object:Any) -> String? {
//        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
//        return nil
//    }
//        return String(data: data, encoding: String.Encoding.utf8)
//    }
//
//
//    func addRecipe(userId:String, privateRecipe:String, title:String, description:String, servings:String, ingredient:Array<Any>, ingredientAmount:Array<Any>, cookWare:Array<Any>, prepTime:String,file:String, steps:Array<Any>,recipeImage:UIImage, completion: @escaping (Bool, Error?) ->Void) {
//
//           let parameters: Parameters = [API.addRecipeFields.userId:userId, API.addRecipeFields.privateRecipe:privateRecipe, API.addRecipeFields.title:title, API.addRecipeFields.description:description, API.addRecipeFields.servings:servings, API.addRecipeFields.cookware:cookWare, API.addRecipeFields.ingredient:ingredient, API.addRecipeFields.ingredientAmount:ingredientAmount, API.addRecipeFields.prepTime:prepTime, API.addRecipeFields.file:file, API.addRecipeFields.steps:steps]
//
//
//            // Start Alamofire
//            Alamofire.upload(multipartFormData: { (multipartFormData) in
//                multipartFormData.append(UIImageJPEGRepresentation(recipeImage, 0.5)!, withName: "file", fileName: AddRecipe.filePath, mimeType: "image/jpeg")
//                for (key, value) in parameters {
//                    if key == API.addRecipeFields.cookware {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else if key ==  API.addRecipeFields.ingredient {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else if key ==  API.addRecipeFields.ingredientAmount {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else if key == API.addRecipeFields.steps {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else {
//                        print("lkey\(key)")
//                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                    }
//                }
//            }, to:API.Users.addRecipe)
//            { (result) in
//                switch result {
//                    case .success(let upload, _, _):
//                    upload.uploadProgress(closure: { (Progress) in
//                    print("Upload Progress: \(Progress.fractionCompleted)")
//            })
//
//        upload.responseJSON { response in
//            print(response)
//             return completion (true, nil)
////            if let dict = response.result.value {
////                print(dict)
////                  return completion (true, nil)
////            }
//        }
//        case .failure(let encodingError):
//        //self.delegate?.showFailAlert()
//         return completion (false, encodingError)
//      }
//    }
//}
//
//    func addRecipe(userId:String, privateRecipe:String, title:String, description:String, servings:String, ingredient:Array<Any>, ingredientAmount:Array<Any>, cookWare:Array<Any>, prepTime:String,file:String, steps:Array<Any>, completion: @escaping (Bool, Error?) ->Void) {
//
//           let parameters: Parameters = [API.addRecipeFields.userId:userId, API.addRecipeFields.privateRecipe:privateRecipe, API.addRecipeFields.title:title, API.addRecipeFields.description:description, API.addRecipeFields.servings:servings, API.addRecipeFields.cookware:cookWare, API.addRecipeFields.ingredient:ingredient, API.addRecipeFields.ingredientAmount:ingredientAmount, API.addRecipeFields.prepTime:prepTime, API.addRecipeFields.file:file, API.addRecipeFields.steps:steps]
//
//
//            // Start Alamofire
//            Alamofire.upload(multipartFormData: { (multipartFormData) in
//                for (key, value) in parameters {
//                    if key == API.addRecipeFields.cookware {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else if key ==  API.addRecipeFields.ingredient {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else if key ==  API.addRecipeFields.ingredientAmount {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else if key == API.addRecipeFields.steps {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else {
//                        print("lkey\(key)")
//                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                    }
//                }
//            }, to:API.Users.addRecipe)
//            { (result) in
//                switch result {
//                    case .success(let upload, _, _):
//                    upload.uploadProgress(closure: { (Progress) in
//                    print("Upload Progress: \(Progress.fractionCompleted)")
//            })
//
//        upload.responseJSON { response in
//            print(response)
//             return completion (true, nil)
////            if let dict = response.result.value {
////                print(dict)
////                  return completion (true, nil)
////            }
//        }
//        case .failure(let encodingError):
//        //self.delegate?.showFailAlert()
//         return completion (false, encodingError)
//      }
//    }
//}
//
//
//
//func editRecipe(userId:String, id:String, privateRecipe:String, title:String, description:String, servings:String, ingredient:Array<Any>, ingredientAmount:Array<Any>, cookWare:Array<Any>, prepTime:String,file:String, steps:Array<Any>,recipeImage:UIImage, completion: @escaping (Bool, Error?) ->Void) {
//
//           let parameters: Parameters = [API.addRecipeFields.recipeId:id, API.addRecipeFields.userId:userId, API.addRecipeFields.privateRecipe:privateRecipe, API.addRecipeFields.title:title, API.addRecipeFields.description:description, API.addRecipeFields.servings:servings, API.addRecipeFields.cookware:cookWare, API.addRecipeFields.ingredient:ingredient, API.addRecipeFields.ingredientAmount:ingredientAmount, API.addRecipeFields.prepTime:prepTime, API.addRecipeFields.file:file, API.addRecipeFields.steps:steps]
//
//            // Start Alamofire
//            Alamofire.upload(multipartFormData: { (multipartFormData) in
//                multipartFormData.append(UIImageJPEGRepresentation(recipeImage, 0.5)!, withName: "file", fileName: getRecipe.filePath, mimeType: "image/jpeg")
//                for (key, value) in parameters {
//                    if key == API.addRecipeFields.cookware {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else if key ==  API.addRecipeFields.ingredient {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else if key ==  API.addRecipeFields.ingredientAmount {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else if key == API.addRecipeFields.steps {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else {
//                        print("lkey\(key)")
//                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                    }
//                }
//            }, to:API.Users.editRecipe)
//            { (result) in
//                switch result {
//                    case .success(let upload, _, _):
//                    upload.uploadProgress(closure: { (Progress) in
//                    print("Upload Progress: \(Progress.fractionCompleted)")
//            })
//
//        upload.responseJSON { response in
//            print(response)
//             return completion (true, nil)
////            if let dict = response.result.value {
////                print(dict)
////                  return completion (true, nil)
////            }
//        }
//        case .failure(let encodingError):
//        //self.delegate?.showFailAlert()
//         return completion (false, encodingError)
//      }
//    }
//}
//
//func editRecipe(userId:String, id:String, privateRecipe:String, title:String, description:String, servings:String, ingredient:Array<Any>, ingredientAmount:Array<Any>, cookWare:Array<Any>, prepTime:String,file:String, steps:Array<Any>, completion: @escaping (Bool, Error?) ->Void) {
//
//           let parameters: Parameters = [API.addRecipeFields.recipeId:id, API.addRecipeFields.userId:userId, API.addRecipeFields.privateRecipe:privateRecipe, API.addRecipeFields.title:title, API.addRecipeFields.description:description, API.addRecipeFields.servings:servings, API.addRecipeFields.cookware:cookWare, API.addRecipeFields.ingredient:ingredient, API.addRecipeFields.ingredientAmount:ingredientAmount, API.addRecipeFields.prepTime:prepTime, API.addRecipeFields.file:file, API.addRecipeFields.steps:steps]
//
//            // Start Alamofire
//            Alamofire.upload(multipartFormData: { (multipartFormData) in
//                for (key, value) in parameters {
//                    if key == API.addRecipeFields.cookware {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else if key ==  API.addRecipeFields.ingredient {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else if key ==  API.addRecipeFields.ingredientAmount {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else if key == API.addRecipeFields.steps {
//                        multipartFormData.append((self.json(from: value)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
//                    } else {
//                        print("lkey\(key)")
//                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                    }
//                }
//            }, to:API.Users.editRecipe)
//            { (result) in
//                switch result {
//                    case .success(let upload, _, _):
//                    upload.uploadProgress(closure: { (Progress) in
//                    print("Upload Progress: \(Progress.fractionCompleted)")
//            })
//
//        upload.responseJSON { response in
//            print(response)
//             return completion (true, nil)
////            if let dict = response.result.value {
////                print(dict)
////                  return completion (true, nil)
////            }
//        }
//        case .failure(let encodingError):
//        //self.delegate?.showFailAlert()
//         return completion (false, encodingError)
//      }
//    }
//}
//
//
//
// // MARK: - profileInfo
//    func editRecipe(recipeId:Double, completion: @escaping (Bool, Error?) ->Void) {
//       let url = API.Users.getRecipe
//        let parameter: Parameters = [API.editRecipeFields.recipeId:recipeId]
//        AlamofireManagaer.request(url, method: .post, parameters: parameter, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
//            let validation = self.validate(response)
//            guard validation.status, let dict: [String:Any] = validation.dict else {
//                return completion (false, validation.error)
//            }
//            RecipeInfo.getRecipeData(dict)
//             completion(true,nil)
//        }
//    }
//
////      func displayRecipe() {
////       let url = "https://plate-date.herokuapp.com/api/recipes/displayRecipe"
////        let parameter: Parameters = ["private":"0"]
////
////
////
////    }
//
//
//     //MARK: - Helper methods
//    func validate(_ response: DataResponse<Any>) -> (status: Bool, error: Error?, dict: [String: Any]?) {
//        print(response)
//       print(response.result.value)
//        let dict = response.result.value as? [String: Any]
//        print(response.response?.statusCode)
//
//        guard (response.response?.statusCode == 200) else {
//            return (false, response.result.value as? Error, nil)
//        }
//        return (true, nil, dict)
//    }
//}
//
//
//
//// MARK: - API Error
//enum APIError: Error {
//    case errorMessage(String?)
//}
//
//func APIErrorMessage() {
//
//}
//
//extension APIError: LocalizedError {
//    public var errorDescription: String? {
//        switch self {
//        case .errorMessage(let message):
//            let text = message ?? ""
//            return NSLocalizedString(text, comment: "")
//        }
//    }
//}
//
