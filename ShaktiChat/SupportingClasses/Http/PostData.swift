//
//  PostData.swift
//  ShaktiChat
//
//  Created by mac on 29/09/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit

class PostData: NSObject {

    func uploadData(url: URL, data: Data?, params: [String: String])
    {
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData;
        let request = NSMutableURLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 6.0);
        request.httpMethod = "POST";
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        //if(data == nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: params, filePathKey: "file", data: data, boundary: boundary)
        
        
        
        //myActivityIndicator.startAnimating();
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            // Print out reponse body
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            
            print("****** response data = \(responseString!)")
            
            
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                print("json-\(json)-")
            } catch {
                //if you recieve an error saying that the data could not be uploaded,
                //make sure that the upload size is set to something higher than the size
                print(error)
            }
            
            
        }
        
        task.resume()
        
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, data: Data?, boundary: String) -> Data {
        var body = Data();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        if data != nil {
            let mimetype = "text/csv"
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(parameters!["filename"]!)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            
            body.append(data!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        }
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
