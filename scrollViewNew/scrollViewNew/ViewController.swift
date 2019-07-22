//
//  ViewController.swift
//  scrollViewNew
//
//  Created by Алексей Перов on 7/21/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imagesScrollView: UIScrollView! {
        didSet {
            imagesScrollView.delegate = self
            imagesScrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    @IBOutlet weak var startLoadingButton: UIButton! {
        didSet {
            startLoadingButton.frame.size.height = 40
//            startLoadingButton.frame.origin = CGPoint(x: 0, y: 0)
            startLoadingButton.frame.size.width = imagesScrollView.frame.size.width
            imagesScrollView.contentSize.height += startLoadingButton.frame.size.height
        }
    }
    private var pictures = ["https://images.pexels.com/photos/1766478/pexels-photo-1766478.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260", "https://images.pexels.com/photos/933498/pexels-photo-933498.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260", "https://images.pexels.com/photos/2559175/pexels-photo-2559175.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260", "https://images.pexels.com/photos/1138149/pexels-photo-1138149.jpeg?cs=srgb&dl=blur-body-clean-1138149.jpg&fm=jpg", "https://images.pexels.com/photos/2259232/pexels-photo-2259232.jpeg?cs=srgb&dl=abstract-background-dew-2259232.jpg&fm=jpg", "https://images.pexels.com/photos/1858409/pexels-photo-1858409.jpeg?cs=srgb&dl=blue-canvas-design-1858409.jpg&fm=jpg", "https://images.pexels.com/photos/1824354/pexels-photo-1824354.jpeg?cs=srgb&dl=food-fruit-healthy-1824354.jpg&fm=jpg", "https://images.pexels.com/photos/1769356/pexels-photo-1769356.jpeg?cs=srgb&dl=architectural-design-architecture-building-1769356.jpg&fm=jpg"]
    
    private var picturesAreLoaded: Bool = false
    private var picturesAreLoading: Bool = false
    private var loadingState: LoadingState = LoadingState.isNotLoaded
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func loadPictures(pictures: [String]) {
        loadingState = .isLoading
        startLoadingButton.setTitle("downloading \(pictures.count) items", for: .normal)
//        startLoadingButton.setTitle("stop", for: .normal)
        var downloadedItems = 0
            for i in 0..<pictures.count {
                DispatchQueue.main.async {
                    let imageView = UIImageView(frame: CGRect(x: 0, y: self.imagesScrollView.contentSize.height, width: UIScreen.main.bounds.width, height: 500))
                    imageView.contentMode = .scaleToFill
                    imageView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                    let activityIndicator = UIActivityIndicatorView()
                    imageView.addSubview(activityIndicator)
                    activityIndicator.center = CGPoint(x: imageView.frame.size.width/2, y: imageView.frame.size.height/2)
                    activityIndicator.startAnimating()
                    self.imagesScrollView.addSubview(imageView)
                    self.imagesScrollView.contentSize.height += imageView.frame.size.height
                    DispatchQueue.global(qos: .userInitiated).async {
                        if let url = URL(string: pictures[i]), let data = try? Data(contentsOf: url), let image = UIImage(data: data), self.loadingState == .isLoading {
                            DispatchQueue.main.async {
                                imageView.image = image
                                activityIndicator.stopAnimating()
                                downloadedItems += 1
                                self.startLoadingButton.setTitle("downloading \(pictures.count - downloadedItems) items", for: .normal)
                                if downloadedItems == pictures.count {
                                    self.startLoadingButton.setTitle("delete", for: .normal)
                                    self.loadingState = .isloaded
                                    
                                }
                                
                                
                            }
                        }
                    }
                }
        }
    }

    @IBAction func startLoadingButtonTouched(_ sender: UIButton) {
        switch loadingState {
        case .isloaded:
            for subview in self.imagesScrollView.subviews where subview is UIImageView {
                subview.removeFromSuperview()
            }
            loadingState = .isNotLoaded
            imagesScrollView.contentSize.height = startLoadingButton.frame.size.height
            startLoadingButton.setTitle("download", for: .normal)
        case .isNotLoaded:
            DispatchQueue.global(qos: .userInitiated).sync {
                loadPictures(pictures: pictures)
            }
        case .isLoading:
            for subview in self.imagesScrollView.subviews where subview is UIImageView {
                if (subview as! UIImageView).image == nil {
                    subview.removeFromSuperview()
                }
            }
            var subviews: [UIImageView] = []
            for subview in imagesScrollView.subviews where subview is UIImageView {
                if (subview as! UIImageView).image != nil {
                    subviews.append((subview as! UIImageView))
                }
            }
            for subview in imagesScrollView.subviews where subview is UIImageView {
                subview.removeFromSuperview()
            }
            imagesScrollView.contentSize.height = startLoadingButton.frame.size.height
            for subview in subviews {
                subview.frame.origin = CGPoint(x: 0.0, y: CGFloat(imagesScrollView.contentSize.height))
                imagesScrollView.contentSize.height += subview.frame.size.height
                imagesScrollView.addSubview(subview)
            }
            self.loadingState = .isloaded
            startLoadingButton.setTitle("delete", for: .normal)
        default:
            break
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    
}

enum LoadingState {
    case isloaded
    case isLoading
    case isNotLoaded
}
