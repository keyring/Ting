//
//  ViewController.swift
//  Ting
//
//  Created by keyring on 11/3/15.
//  Copyright © 2015 cude. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, HttpProtocol {

    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var btn_prev: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var progressSlider: CircleProgress!
    var ehttp: HttpController = HttpController()
    var tableData = NSMutableArray()
    var playSong = Song()
    var audioPlayer = MPMoviePlayerController()
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.view.frame
//        backgroundImage.addSubview(blurEffectView)
        setupProgressSlider()
        ehttp.delegate = self
        ehttp.onSearch("http://douban.fm/j/mine/playlist?channel=1")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didReceiveResults(result:NSDictionary){
        NSLog("%@",result)
        if(result["song"] != nil){
            let resultData = result["song"] as! NSArray
            let list = NSMutableArray()
            
            for(var index = 0; index < resultData.count; index++){
                var dic = resultData[index] as! NSDictionary
                var song = Song()
                song.setValuesForKeysWithDictionary(dic as! [String : AnyObject])
                list.addObject(song)
            }
            self.tableData = list
            self.playNextSong()
        }
    }
    
    func setupProgressSlider() {
        progressSlider = CircleProgress(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2))
        progressSlider.colors = [0xA6E39D, 0xAEC1E3, 0xAEC1E3, 0xF3C0AB]
        
        self.view.addSubview(progressSlider)
    }
    
    func setCurrentSong(curSong:Song){
        playSong = curSong
        if let url = NSURL(string: playSong.picture as String){
            if let data = NSData(contentsOfURL: url){
                backgroundImage.contentMode = UIViewContentMode.ScaleAspectFit
                backgroundImage.image = UIImage(data: data)
            }
        }
        btn_play.selected = true
        progressSlider.progress = 0.0
        audioPlayer.stop()
        audioPlayer.contentURL = NSURL(string: playSong.url as String)
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        
        audioPlayer.play()
    }
    
    func playNextSong(){
        if (self.tableData.count <= 0) {
            ehttp.onSearch("http://douban.fm/j/mine/playlist?channel=1")
            return
        }
        self.setCurrentSong(self.tableData[self.tableData.count-1] as! Song)
        self.tableData.removeLastObject()

    }
    
    func updateTimer(){
        let c = audioPlayer.currentPlaybackTime
        
        if c > 0.0 {
            let t = audioPlayer.duration
            let percent = CDouble(c/t)
            progressSlider.progress = percent
            
            if c >= t {
                playNextSong()
            }
        }
        
    }
    
    @IBAction func playOrPauseSong(sender: UIButton) {
        if (sender.selected){
            audioPlayer.pause()
        }else{
            audioPlayer.play()
        }

        sender.selected = !sender.selected
    }
    
    @IBAction func nextSong(sender: UIButton) {
        playNextSong()
    }

}

