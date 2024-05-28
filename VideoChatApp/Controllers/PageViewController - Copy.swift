//
//  PageViewController.swift
//  VideoChatApp
//
//  Created by Apple on 04/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
//    lazy var viewControllerArr : [UIViewController] = {
//        return [
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlugIn"),
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Birthname"),
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Stagename"),
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GenderScreen"),
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BirthDate"),
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationScreen"),
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Ethnicity"),
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicGenre"),
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicDuration"),
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicIndustry"),
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
//        ]
//    }()
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController(color: "PlugIn"),
            self.newColoredViewController(color: "Birthname"),
            self.newColoredViewController(color: "GenderScreen"),self.newColoredViewController(color: "BirthDate"),self.newColoredViewController(color: "LocationScreen"),self.newColoredViewController(color: "Ethnicity"),self.newColoredViewController(color: "MusicGenre"),self.newColoredViewController(color: "MusicDuration"),self.newColoredViewController(color: "MusicIndustry"),self.newColoredViewController(color: "UploadDP"),self.newColoredViewController(color: "UploadCoverPhoto")]
    }()
    
    private func newColoredViewController(color: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(color)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if AuthenticationService.shared.boolOpenPageViewBySetting{
            
           let cont =  Constants.shared.viewControllerArr[1]
            self.setViewControllers([cont], direction: .forward, animated: true, completion: nil)
//            if let firstViewController = orderedViewControllers.first {
//                setViewControllers([firstViewController],
//                                   direction: .forward,
//                    animated: true,
//                    completion: nil)
//            }
        }else{
            if let firstViewController = orderedViewControllers.first {
                setViewControllers([firstViewController],
                                   direction: .forward,
                    animated: true,
                    completion: nil)
            }
        }
        
            
        
    }
   
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("swipe backward")
        guard let viewControllerIndex = Constants.shared.viewControllerArr.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return Constants.shared.viewControllerArr.last
        }
        
        guard Constants.shared.viewControllerArr.count > previousIndex else {
            return nil
        }
        
        return Constants.shared.viewControllerArr[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("swipe forward")
        
        
        guard let viewControllerIndex = Constants.shared.viewControllerArr.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = Constants.shared.viewControllerArr.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return Constants.shared.viewControllerArr.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return Constants.shared.viewControllerArr[nextIndex]
       
    }
    
    
}
