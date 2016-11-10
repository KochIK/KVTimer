//
//  Created by Vlad Kochergin on 11.08.16.
//  Copyright © 2016 All rights reserved.
//


#import <UIKit/UIKit.h>
#import "KVStyle.h"

@class KVTimer;

typedef enum KVInterval : NSInteger {
    KVIntervalSecond = 1,
    KVIntervalMinute = 60,
    KVIntervalHour = 60*59
} KVInterval;

@protocol KVTimerDelegate

-(void)getTimer:(NSString *)time;
-(void)endTime;

@end

@interface KVTimer : UIView

@property (nonatomic,weak) NSObject<KVTimerDelegate> *delegate;

@property (nonatomic) KVInterval interval; //default KVIntervalSecond
@property (nonatomic, strong, readonly) KVStyle *pinStyle;
@property (nonatomic, strong, readonly) KVStyle *circleStyle;
@property (nonatomic, strong, readonly) KVStyle *lineStyle;

@property (nonatomic) BOOL showTimerLabel; //default NO;
@property (nonatomic) BOOL showKofLabel; //default NO;
@property (nonatomic, strong) NSString *kofString;
@property (nonatomic, readonly, getter=isTimerActive) BOOL timerActive;

- (void)setStylePin:(KVStyle *)style;
- (void)setStyleLine:(KVStyle *)style;
- (void)setStyleCircle:(KVStyle *)style;

- (void)setMaxTime:(NSInteger)max minTime:(NSInteger)min;

- (void)startTimer:(BOOL)start;

- (void)stopTimer;

//-(void)forwardGesture:(UIPanGestureRecognizer *)sender;
@end
