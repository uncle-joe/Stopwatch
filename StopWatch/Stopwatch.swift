//
//  Stopwatch.swift
//  StopWatch
//
//  Created by Sergey Kaminski on 1/9/15.
//  Copyright (c) 2015 Sergey Kaminski. All rights reserved.
//

import Cocoa
import Foundation

public enum StopwatchState {
    case Paused
    case Running
    case Stopped
    case Halted
}


public typealias OnTimerUpdateFunc = (Int, Int) -> Bool
public typealias OnChangeStateFunc = (StopwatchState) -> Bool


public class Stopwatch: NSObject {
    private var timer: NSTimer!
    private var state: StopwatchState = StopwatchState.Paused
    
    private var startTime: NSDate = NSDate()
    internal var totalInterval: NSTimeInterval = 0;
    
    public var OnTimerUpdate: OnTimerUpdateFunc?
    public var OnStateChange: OnChangeStateFunc?
    
    init (fromHours: Int, minutes: Int) {
        totalInterval = NSTimeInterval((minutes * 60) + (fromHours * 60 * 60))

    }
    
    public func SetTime (hours: Int, minutes: Int, seconds: Int) {
        totalInterval = NSTimeInterval((minutes * 60) + (hours * 60 * 60) + seconds);
    }
    
    public var State: StopwatchState {
        get {
            return state;
        }
    }
    
    public var TotalSeconds: Int {
        get {
            return Int(totalInterval);
        }
    }
    
    public func GetTime () -> (hours: Int, minutes: Int, seconds: Int)  {
        let t = Int(totalInterval);
        let h = Int(t / 3600);
        let hs = h * 3600;
        let m = (t - hs) / 60;
        let ms = m * 60;
        var s = t - hs - ms;
        
        return (h, m, s);
    }
    
    
    internal func ChangeState (state: StopwatchState) {
        self.state = state;
        if let onChange = OnStateChange {
            onChange(state);
        }
    }
    
    public func Resume () {
        if (state == StopwatchState.Paused) {
            startTime = NSDate();
            if (timer == nil || !timer.valid) {
                timer = NSTimer.scheduledTimerWithTimeInterval(0.5,
                    target: self,
                    selector: Selector("Update"),
                    userInfo: nil,
                    repeats: true);
                
            }
            ChangeState(StopwatchState.Running)
        }
    }
    
    public func Pause () {
        if (state == StopwatchState.Running){
            timer.invalidate();
            let interval = -startTime.timeIntervalSinceNow;
            let t = totalInterval - interval;
            totalInterval = t;
            ChangeState(StopwatchState.Paused)
        }
    }
    
    public func Stop () {
        if (state == StopwatchState.Running || state == StopwatchState.Paused){
            totalInterval = 0;
            ChangeState(StopwatchState.Stopped);
            timer.invalidate();
        }
    }
    
    public func Halt() {
        if (state == StopwatchState.Running || state == StopwatchState.Paused){
            totalInterval = 0;
            ChangeState(StopwatchState.Halted);
            timer.invalidate();
        }
    }
    
    func Update () {
        if (timer.valid) {
            let interval = -startTime.timeIntervalSinceNow;
            let t = totalInterval - interval;
            
            if let onUpdate = OnTimerUpdate {
                onUpdate(Int(interval), Int(t));
            }
            
            totalInterval = t;
            startTime = NSDate();
            
            if (totalInterval <= 0) {
                Stop();
            }
        }
    }
}
