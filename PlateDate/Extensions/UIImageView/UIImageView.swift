//
//  UIImageView.swift
//  PlateDate
//
//  Created by WebCrafters on 01/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
import Kingfisher 

typealias ImageLoaded = (_ image: UIImage?) -> Void

protocol FetchImageTask {
    func cancel()
}

extension RetrieveImageTask: FetchImageTask { }

extension UIImageView {

    @discardableResult
    func loadImage(fromUrl url: String?, withParams params: LoadImageParams =  LoadImageParams(), completion: ImageLoaded? = nil) -> FetchImageTask? {
        guard let url = url, let imageUrl = URL(string: url) else {
            resetImage(with: params)
            return nil
        }
        setupImageView(with: params)
        let cornerProcessor = RoundCornerImageProcessor(cornerRadius: params.cornerRadius)
        let resizeProcessor = ResizingImageProcessor(referenceSize: frame.size, mode: .aspectFill)
        let processor: ImageProcessor = params.resizeBeforeCaching ? (resizeProcessor >> cornerProcessor) : cornerProcessor

        self.kf.indicatorType = params.showActivityIndicator ? .activity : .none

        var options: KingfisherOptionsInfo = [.processor(processor), .transition(.fade(0.3))]
        if params.forceRefresh {
            options.append(.forceRefresh)
        }

        let task = kf.setImage(with: imageUrl, placeholder: params.placeholder, options: options, progressBlock: nil) { (image, error, cacheType, _) in //(image, error, cacheType, url)
            if let image = image {
                ImageCache.default.store(image, forKey: url) } // Forcing cache for now because kingfisher is not optmized for low number of photos. Once the user start having
            // lots of photos or if a feed is created this should be removed
            self.isUserInteractionEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                completion?(image)
            }
        }
        return task
    }

    // MARK: - Private methods

    private func setupImageView(with params: LoadImageParams) {
        layer.masksToBounds = true
        contentMode = params.contentMode
        isUserInteractionEnabled = false
        backgroundColor = params.backgroundColor
    }

    private func resetImage(with params: LoadImageParams) {
        image = params.placeholder
        contentMode = params.placeholderContentMode
        self.backgroundColor = backgroundColor
    }
}


public class EdgeShadowLayer: CAGradientLayer {

    public enum Edge {
        case Top
        case Left
        case Bottom
        case Right
    }

    public init(forView view: UIView,
                edge: Edge = Edge.Top,
                shadowRadius radius: CGFloat = 20.0,
                toColor: UIColor = UIColor.white,
                fromColor: UIColor = UIColor.black) {
        super.init()
        self.colors = [fromColor.cgColor, toColor.cgColor]
        self.shadowRadius = radius
        let viewFrame = view.frame
        switch edge {
            case .Top:
                startPoint = CGPoint(x: 0.5, y: 0.0)
                endPoint = CGPoint(x: 0.5, y: 1.0)
                self.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: shadowRadius)
            case .Bottom:
                startPoint = CGPoint(x: 0.5, y: 1.0)
                endPoint = CGPoint(x: 0.5, y: 0.0)
                self.frame = CGRect(x: 0.0, y: viewFrame.height - shadowRadius, width: viewFrame.width, height: shadowRadius)
            case .Left:
                startPoint = CGPoint(x: 0.0, y: 0.5)
                endPoint = CGPoint(x: 1.0, y: 0.5)
                self.frame = CGRect(x: 0.0, y: 0.0, width: shadowRadius, height: viewFrame.height)
            case .Right:
                startPoint = CGPoint(x: 1.0, y: 0.5)
                endPoint = CGPoint(x: 0.0, y: 0.5)
                self.frame = CGRect(x: viewFrame.width - shadowRadius, y: 0.0, width: shadowRadius, height: viewFrame.height)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
