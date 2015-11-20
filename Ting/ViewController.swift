//
//  ViewController.swift
//  Ting
//
//  Created by keyring on 11/3/15.
//  Copyright © 2015 cude. All rights reserved.
//

import UIKit


class ViewController: UIViewController {


    @IBOutlet weak var backgroundImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let str = "http://tu.ihuan.me/api/bing"
         let url = NSURL(string: str)
            if let data = NSData(contentsOfURL: url!){
                backgroundImage.contentMode = UIViewContentMode.ScaleAspectFit
                backgroundImage.image = UIImage(data: data)
            }
        var scrollview = UIScrollView()
        scrollview.frame = self.view.bounds
        scrollview.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height*2)
        scrollview.pagingEnabled = true
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.scrollsToTop = false
        
        var musicControlView = MusicViewController()
        musicControlView.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollview.addSubview(musicControlView.view)
        
        var contentView = ContentViewController()
        contentView.view.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, self.view.frame.height)
        scrollview.addSubview(contentView.view)
        
        self.view.addSubview(scrollview)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

