//
//  PageShowerViewController.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 08/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import UIKit

extension UIPageViewController {
    
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
    }
    
    func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: animated, completion: nil)
    }
    
}

class PageShowerViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var index = 0
    
    var eenpageVC:UIPageViewController?{
        
        didSet{
            //bolletjes aanpassen
            let stijl = UIPageControl.appearance()
            stijl.pageIndicatorTintColor = UIColor(red:0.77, green:0.77, blue:0.77, alpha:1.00)
            stijl.currentPageIndicatorTintColor = UIColor(red:0.23, green:0.74, blue:0.96, alpha:1.00)
        }

    
    }
    
    var viewControllers: [UIViewController] = []

    var storyboardIds = ["page1", "page2", "page3", "page4"]

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if(index>0 && index<storyboardIds.count) {
            return self.storyboard?.instantiateViewController(withIdentifier: storyboardIds[index-1])
        }else {
            return nil
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if(index+1 < storyboardIds.count) {
            return self.storyboard?.instantiateViewController(withIdentifier: storyboardIds[index+1])
        }else{
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) ->
        Int {
            return storyboardIds.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return index
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let viewC = pageViewController.viewControllers?.first
        let identifier = viewC?.restorationIdentifier
        index = storyboardIds.index(of: identifier!)!
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        if segue.identifier == "boardingDone" {
            print("boarding is done")
            
            UserDefaults.standard.set(true, forKey: "boardingDone")
            UserDefaults.standard.synchronize()
        } else {
            eenpageVC = (segue.destination as! UIPageViewController)
            eenpageVC?.delegate = self
            eenpageVC?.dataSource = self
            
            let firstPage = self.storyboard?.instantiateViewController(withIdentifier: storyboardIds[0])
            
            eenpageVC?.setViewControllers([firstPage!], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
}
