//
//  ViewController.swift
//  BNCurvedPageControl
//
//  Created by Bijesh on 12/27/2018.
//  Copyright (c) 2018 Bijesh. All rights reserved.
//

import UIKit
import BNCurvedPageControl

class ViewController: UIViewController, UIScrollViewDelegate, BNCurvedPageControlDelegate {
    
    @IBOutlet var demoView: BNCurvedPageControl!
    @IBOutlet var scrollViewContent: UIScrollView!
    var numberOfPages:Int = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        demoView.buttonColor = self.view.backgroundColor!
        demoView.lineColor = .clear
        demoView.buttonSelectedColor = .white
        demoView.numberOfPoints = numberOfPages
        demoView.delegate = self
        
        scrollViewContent.contentSize = CGSize.init(width: self.view.bounds.size.width * CGFloat(numberOfPages), height: self.view.bounds.size.height)
        
        for i in 0...numberOfPages {
            let xPosition:CGFloat = self.view.bounds.size.width * CGFloat(i)
            let label:UILabel = UILabel.init(frame: CGRect.init(x: xPosition, y: 100, width: self.view.bounds.size.width, height: 40))
            label.text = "\(i+1)"
            label.font = UIFont.boldSystemFont(ofSize: 40)
            label.textAlignment = .center
            label.textColor = UIColor.white
            scrollViewContent.addSubview(label)
        }
        
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        demoView.goToIndicator(x: Int(pageNumber))
    }
    
    //MARK: BNPageControlDelegate
    func goToPage(_ button: UIButton!) {
        let xPosition = CGFloat(button.tag) * CGFloat(scrollViewContent.frame.size.width)
        scrollViewContent.setContentOffset(CGPoint(x: xPosition, y: 0), animated: true)
    }
    
}

