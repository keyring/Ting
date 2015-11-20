//
//  MusicViewController.swift
//  Ting
//
//  Created by keyring on 11/20/15.
//  Copyright © 2015 cude. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class MusicViewController: UIViewController, HttpProtocol {


    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var sliderbarImage: UIImageView!
    

    var progressSlider: CircleProgress!
    var ehttp: HttpController = HttpController()
    var tableData = NSMutableArray()
    var playSong = Song()
    var audioPlayer = MPMoviePlayerController()
    var timer = NSTimer()
    var notifycation = NSNotificationCenter.defaultCenter()



    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }catch{
            NSLog("Failed to set audio session category.")
        }
        
        //        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        //        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //        blurEffectView.frame = self.view.frame
        //        backgroundImage.addSubview(blurEffectView)
        setupProgressSlider()
        ehttp.delegate = self
        ehttp.onSearch("http://douban.fm/j/mine/playlist?channel=0")
        
        notifycation.addObserver(self, selector: "playNextSong", name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        
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
        progressSlider = CircleProgress(frame: CGRectMake(0,0, self.sliderbarImage.frame.width, self.sliderbarImage.frame.height))
        progressSlider.colors = [0x000000, 0x000000, 0x000000, 0x000000]
        progressSlider.lineWidth = 5
        progressSlider.progressAlpha = 1
        
        self.sliderbarImage.addSubview(progressSlider)
    }
    
    func setCurrentSong(curSong:Song){
        playSong = curSong
        //        if let url = NSURL(string: playSong.picture as String){
        //            if let data = NSData(contentsOfURL: url){
        //                backgroundImage.contentMode = UIViewContentMode.ScaleAspectFit
        //                backgroundImage.image = UIImage(data: data)
        //            }
        //        }
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
            btn_play.selected = false
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
