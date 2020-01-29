//
//  Azure.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 1/26/20.
//  Copyright © 2020 AKDN. All rights reserved.
//

import Foundation
import AZSClient

class AZSClient {

  static let accKey = String(AppSecrets.azureAccKey.reversed())
  static let serverURL = "https://teamimages.blob.core.windows.net/"
  static let containerName = "teamimages-dev"
  static let accountName = "teamimages"
  static let folderName: String = {
    if UserInfo.isStaging {
        return "staging/"
    } else {
      #if DEBUG
        return "dev/"
      #else
        return ""
      #endif
    }
  }()
  static let connectionString = "DefaultEndpointsProtocol=https;AccountName=\(AZSClient.accountName);AccountKey=\(AZSClient.accKey)"
  static func uploadImage(data imageData: Data, teamName: String, completion: @escaping (Error?, Bool) -> (Void)) {
    do {
      let account = try AZSCloudStorageAccount(fromConnectionString: AZSClient.connectionString)
      let blobClient = account.getBlobClient()
      let blobContainer = blobClient.containerReference(fromName: containerName)

      blobContainer.createContainerIfNotExists { (error, exists) in
        if let err = error {
          print("Error in creating container: \(err)")
          completion(err, false)
        } else {
          let fileName = folderName+teamName.trimmingCharacters(in: .whitespaces)+".jpg"
          let blob = blobContainer.blockBlobReference(fromName: fileName)
          blob.upload(from: imageData) { (error) in
            if let err = error {
              print("Error uploading image: \(err)")
              completion(err, false)
            } else {
              print(fileName, "uploaded!")
              completion(nil, true)
            }
          }
        }
      }
    } catch {
        print("Error in creating account: \(error)")
    }
  }

  static func buildImageURL(for imageName: String) -> String {
    return "\(serverURL)\(containerName)/\(folderName)\(imageName).jpg"
  }
}
