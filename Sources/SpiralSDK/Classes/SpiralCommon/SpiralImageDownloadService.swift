//
//  AvatarDownloadService.swift
//  SpiralBank
//
//  Created by Eric Collom on 1/20/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation
//import SDWebImage
import UIKit

protocol SpiralImageDownloadService {
    func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void)
    func populateImageView(_ imageView: UIImageView, urlString: String?, placeholderImage: UIImage?)
    func populateImageView(_ imageView: UIImageView, urlString: String?, placeholderImage: UIImage?, completion: (() -> Void)?)
    func setButtonBackground(_ button: UIButton, urlString: String?, placeholderImage: UIImage?)
}

class SpiralImageDownloadManager: SpiralImageDownloadService {
    
    private var imageViewToUrl = [UIImageView: String]()
    
    func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        let safeUrl = urlString.trimmed.spiralSafeUrl()
        
        guard let url = URL(string: safeUrl) else {
            completion(nil)
            return
        }
        
        downloadImage(with: url, urlString: safeUrl, completion: completion)
    }
    
    private func downloadData(with url: URL, urlString: String, completion:  @escaping (Data?) -> Void) {
        let request = URLRequest(url: url)
//        request.setValue(token, forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let errorDescription = String(describing: error.localizedDescription)
                let dataAsText = String(describing: String(data: data ?? Data(), encoding: .utf8))
                print("******Failed to Download image******\n\(url)\n\(errorDescription)\(dataAsText)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
    
    private func downloadImage(with url: URL, urlString: String, completion: @escaping (UIImage?) -> Void) {
        downloadData(with: url, urlString: urlString) { data in
            if let data = data {
                let image = UIImage.init(data: data)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    func populateImageView(_ imageView: UIImageView, urlString: String?, placeholderImage: UIImage?) {
        populateImageView(imageView,
                          urlString: urlString,
                          placeholderImage: placeholderImage,
                          completion: nil)
    }
    
    func populateImageView(_ imageView: UIImageView, urlString: String?, placeholderImage: UIImage?, completion: (() -> Void)?) {
        
        let setPlaceholderOrClear = {
            imageView.image = placeholderImage ?? nil
        }
        
        guard let urlString = urlString?.trimmed.spiralSafeUrl(), !urlString.isEmpty else {
            setPlaceholderOrClear()
            completion?()
            return
        }
        
        
        
        imageView.image = nil
        
        imageViewToUrl[imageView] = urlString
        
        imageView.findViews(subclassOf: SVGView.self).forEach { $0.removeFromSuperview() }
        if urlString.hasSuffix(".svg"),
            let url = URL(string: urlString) {
            downloadData(with: url, urlString: urlString) { [weak self] data in
                guard self?.imageViewToUrl[imageView] == urlString else { return }
                if let data = data {
                    let svgView = SVGView(svgData: data)
                    svgView.embed(in: imageView)
                    completion?()
                } else {
                    setPlaceholderOrClear()
                    completion?()
                }
            }
        } else {
            downloadImage(urlString: urlString) { [weak self] (image) in
                guard self?.imageViewToUrl[imageView] == urlString else { return }
                
                if let image = image {
                    imageView.image = image
                    completion?()
                } else {
                    setPlaceholderOrClear()
                    completion?()
                }
                
                self?.imageViewToUrl.removeValue(forKey: imageView)
            }
        }
    }
    
    func setButtonBackground(_ button: UIButton, urlString: String?, placeholderImage: UIImage?) {
        let setPlaceholderOrClear = {
            button.setBackgroundImage(placeholderImage ?? nil, for: .normal)
        }
        
        guard let urlString = urlString else {
            setPlaceholderOrClear()
            return
        }
        
        downloadImage(urlString: urlString) { (image) in
            if let image = image {
                button.setBackgroundImage(image, for: .normal)
            } else {
                setPlaceholderOrClear()
            }
        }
    }
}
