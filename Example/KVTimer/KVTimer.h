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

- (void)KVTimer:(KVTimer *)timer willTimeChange:(NSString *)newTime;
- (void)willTimerEnd:(KVTimer *)timer;

@end

@interface KVTimer : UIView

@property (nonatomic,weak) NSObject<KVTimerDelegate> *delegate;

@property (nonatomic, strong, readonly) KVStyle *pinStyle;
@property (nonatomic, strong, readonly) KVStyle *circleStyle;
@property (nonatomic, strong, readonly) KVStyle *lineStyle;
@property (nonatomic) NSInteger currentTime;
@property (nonatomic, strong) NSString *kofString;
@property (nonatomic, readonly, getter=isTimerActive) BOOL timerActive;
/**
 KVIntervalSecond
 Default - NO
 */
@property (nonatomic) KVInterval interval;
/**
 showTimerLabel/showKofLabel
 Default - NO
 */
@property (nonatomic) BOOL showTimerLabel;
@property (nonatomic) BOOL showKofLabel;

- (void)setStylePin:(KVStyle *)style;
- (void)setStyleLine:(KVStyle *)style;
- (void)setStyleCircle:(KVStyle *)style;

- (void)setTime:(NSUInteger)time;
- (void)setMaxTime:(NSInteger)max minTime:(NSInteger)min;
- (void)startTimer:(BOOL)start;
- (void)stopTimer;

@end
