//
//  AppDelegate.swift
//  StopWatch
//
//  Created by Sergey Kaminski on 1/6/15.
//  Copyright (c) 2015 Sergey Kaminski. All rights reserved.
//

import Foundation
import Cocoa
import AppKit
import IOKit
import CoreFoundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var labelCurrentStage: NSTextField!
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet weak var btnStart: NSButton!
    
    var stopwatchRunning: Bool = false
    
    var stopwatch: Stopwatch?
    
    var snd : NSSound? = NSSound(named: "Hero");
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func OnTimerUpdate (interval: Int, totalInterval: Int) -> Bool {
        var time = stopwatch!.GetTime();
        
        let intFormat = "02";
        
        let hoursString = time.hours == 0 ? "" : "\(time.minutes.format(intFormat)):";
        
        labelCurrentStage.stringValue = hoursString + "\(time.minutes.format(intFormat)):\(time.seconds.format(intFormat))";
        
        progressIndicator.doubleValue = Double(stopwatch!.TotalSeconds);
        
        return true;
    }
    
    func OnStateChange (state: StopwatchState) -> Bool {
        
        switch (state) {
        case StopwatchState.Running:
            labelCurrentStage.hidden = false;
            labHMDelim.hidden = true;
            editHours.hidden = true;
            editMinutes.hidden = true;
            progressIndicator.startAnimation(nil);
            
            SleepPreventer.Start();
            
        case StopwatchState.Paused:
            SleepPreventer.Stop();
            return true;
            
        case StopwatchState.Stopped:
            stop();
            alert();
            
        case StopwatchState.Halted:
            stop();
            
        default:
            return false;
        }
        return true;
    }
    
    func stop () {
        labelCurrentStage.hidden = true;
        editHours.hidden = false;
        editMinutes.hidden = false;
        stopwatchRunning = false;
        labHMDelim.hidden = false;
        
        btnStart.setNextState();
        setButtonState();
        
        stopwatch = nil;
        
        progressIndicator.stopAnimation(nil)
        
        SleepPreventer.Stop();
    }
    
    @IBOutlet weak var editMinutes: NSTextField!
    @IBOutlet weak var editHours: NSTextField!
    
    @IBOutlet weak var labHMDelim: NSTextField!
    
    func completionHandler (response : NSModalResponse) {
        snd!.stop();
    }
    
    func alert() {
        
        snd!.loops = true;
        snd!.play();
        
        let modalAlert = NSAlert();
        modalAlert.alertStyle = NSAlertStyle.InformationalAlertStyle;
        modalAlert.messageText = "It's time!";
        modalAlert.beginSheetModalForWindow(self.window!, completionHandler: completionHandler);
        
    }
    
    func setButtonState () {
        var buttonTitle: NSString = "";
        
        switch (stopwatchRunning) {
        case true:
            buttonTitle = "Pause"
        case false:
            buttonTitle = "Start"
        default:
            buttonTitle = ""
        }
        
        btnStart.title = buttonTitle;
    }
    
    @IBAction func btnStart(sender: AnyObject) {
        
        if (stopwatch == nil) {
            stopwatch = Stopwatch(fromHours: editHours.integerValue,
                minutes: editMinutes.integerValue);
            //stopwatch!.SetTime(0,minutes:0,seconds:4);
            
            progressIndicator.doubleValue = 0;
            progressIndicator.maxValue = Double (stopwatch!.TotalSeconds)
            progressIndicator.minValue = 0;
        }
        
        stopwatchRunning = !stopwatchRunning
        
        setButtonState ();
        
        stopwatch!.OnTimerUpdate = self.OnTimerUpdate;
        stopwatch!.OnStateChange = self.OnStateChange;
        
        if stopwatchRunning {
            stopwatch!.Resume();
        }
        else {
            stopwatch!.Pause();
        }
    }
    
    @IBAction func btnReset(sender: AnyObject) {
        editHours.integerValue = 0;
        editMinutes.integerValue = 0;
        
        if (stopwatch != nil){
            stopwatch!.Halt();
        }
    }
    
}

