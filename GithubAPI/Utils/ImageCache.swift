//
//  ImageCache.swift
//  GithubAPI
//
//  Created by tauta on 7/2/19.
//  Copyright © 2019 kamalqawlaq. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
  
  let imageCache = NSCache<NSString, UIImage>()
  
  private init(){}
  public static let shared = ImageCache()
  
  func getUserAvatarImageFromCache(_ key: String) -> UIImage? {
    return imageCache.object(forKey: key as NSString)
  }
  
  func cacheUserAvatarImage(_ key: String, userAvatarImage: UIImage) {
    imageCache.setObject(userAvatarImage, forKey: key as NSString)
  }
}
