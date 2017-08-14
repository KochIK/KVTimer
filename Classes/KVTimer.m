//
//  Created by Vlad Kochergin on 11.08.16.
//  Copyright © 2016 All rights reserved.
//


#import "KVTimer.h"

#define dRADIUS MIN(self.frame.size.height/2, self.frame.size.width/2)
#define dDEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface KVTimer ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) CAShapeLayer *circle;
@property (strong, nonatomic) CAShapeLayer *pin;
@property (strong, nonatomic) CAShapeLayer *baseCircle;

@property (nonatomic) float currentAngle;
@property (nonatomic) NSInteger startTime;
@property (nonatomic) NSUInteger timeMin;
@property (nonatomic) CGFloat timeMax;
@property (nonatomic) BOOL timerActive;

@property (nonatomic, strong) KVStyle *pinStyle;
@property (nonatomic, strong) KVStyle *circleStyle;
@property (nonatomic, strong) KVStyle *lineStyle;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *kofLabel;

@end

static const NSInteger defaultRadius = 10;
static const NSInteger endAngleCircle = 10;
static const CGFloat startAngleCircle = -1.57;
static const CGFloat coefficient = 0.070833;

@implementation KVTimer

#pragma mark - Getters

- (NSInteger)currentTime{
    if(!_currentTime)
        return self.timerActive ? 0 : _timeMin+1;
    return _currentTime;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultConfiguration];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
        
        self.circle = [CAShapeLayer layer];
        self.pin = [CAShapeLayer layer];
        
        [self.layer addSublayer:self.pin];
        [self.layer addSublayer:self.circle];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupDefaultConfiguration];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
        
        self.circle = [CAShapeLayer layer];
        self.pin = [CAShapeLayer layer];
        
        [self.layer addSublayer:self.pin];
        [self.layer addSublayer:self.circle];
    }
    return self;
}

- (void)setupDefaultConfiguration{
    self.timeMin = 0;
    self.timeMax = 60;
    self.interval = KVIntervalSecond;
    
    KVStyle *pinStyle = [KVStyle initWithFillColor:[UIColor whiteColor] strokeColor:[UIColor clearColor] lineWidth:2 radius:defaultRadius];
    [self setPinStyle:pinStyle];
    
    KVStyle *circleStyle = [KVStyle initWithFillColor:[UIColor clearColor] strokeColor:[UIColor colorWithWhite:1.0 alpha:0.3] lineWidth:2 radius:dRADIUS];
    [self setCircleStyle:circleStyle];
    
    KVStyle *lineStyle = [KVStyle initWithFillColor:[UIColor clearColor] strokeColor:[UIColor whiteColor] lineWidth:2 radius:dRADIUS];
    [self setStyleLine:lineStyle];
}

- (void)setupView{
    [self setBackgroundColor:[UIColor clearColor]];
    self.baseCircle = [CAShapeLayer new];
    self.currentTime = self.timeMin;
    self.baseCircle.fillColor = self.circleStyle.fillColor.CGColor;
    self.baseCircle.strokeColor = self.circleStyle.strokeColor.CGColor;
    self.baseCircle.lineWidth = self.circleStyle.lineWidth;
    [self.baseCircle removeFromSuperlayer];
    
    self.baseCircle.path = [UIBezierPath bezierPathWithArcCenter:
                            CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
                                                          radius:self.circleStyle.radius
                                                      startAngle:0
                                                        endAngle:endAngleCircle clockwise:YES].CGPath;
    [self.layer addSublayer:self.baseCircle];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupView];
    [self panGestureRecognized:nil];
}

- (void)setTimerPosition{
    CGPoint position = [self handePosition];
    
    if(!self.timerActive){
        NSInteger minutesFloat =(atan2f(position.x - self.frame.size.width / 2, position.y - self.frame.size.height / 2) * -(180 / M_PI) + 180)/self.timeMax;
        if(minutesFloat<self.timeMin){
            minutesFloat = self.timeMin+1;
        }
        self.currentTime = minutesFloat;
    }
    position = [self timeToCoordinate];
    
    self.circle.path = [UIBezierPath bezierPathWithArcCenter:
                        CGPointMake(self.frame.size.width / 2, self.frame.size.height/2)
                                                      radius: self.lineStyle.radius
                                                  startAngle: startAngleCircle
                                                    endAngle: self.currentAngle
                                                   clockwise: YES].CGPath;
    
    self.pin.path = [UIBezierPath bezierPathWithArcCenter:
                     CGPointMake(position.x, position.y)
                                                   radius: self.pinStyle.radius
                                               startAngle: startAngleCircle
                                                 endAngle: endAngleCircle
                                                clockwise: YES].CGPath;
    
    self.pin.fillColor = self.pinStyle.fillColor.CGColor;
    self.circle.fillColor = self.lineStyle.fillColor.CGColor;
    self.circle.strokeColor = self.lineStyle.strokeColor.CGColor;
    self.circle.lineWidth = self.lineStyle.lineWidth;
    
    self.showTimerLabel ? [self showLabelTime] : 0;
    self.showKofLabel ? [self showLabelKof] : 0;
    
    if([self.delegate respondsToSelector:@selector(KVTimer:willTimeChange:)]){
        [self.delegate KVTimer:self willTimeChange:[NSString stringWithFormat:@"%li", (long)self.currentTime]];
    }
}

- (CGPoint)handePosition{
    double tx = self.circleStyle.radius*cosf(self.currentAngle) + self.frame.size.width / 2;
    double ty = self.circleStyle.radius*sinf(self.currentAngle) + self.frame.size.height / 2;
    
    return CGPointMake(tx, ty);
}

- (CGPoint)timeToCoordinate{
    float alpha=90-360 / (360 / self.timeMax)*self.currentTime;
    float tx= self.frame.size.width / 2 + self.circleStyle.radius*cos(dDEGREES_TO_RADIANS(alpha));
    float ty= self.frame.size.height / 2 + -self.circleStyle.radius*sin(dDEGREES_TO_RADIANS(alpha));
    
    CGFloat angleInRadians = atan2f(ty - self.frame.size.height / 2, tx - self.frame.size.width / 2);
    
    float angle = angleInRadians + M_PI / 180;
    self.currentAngle = angle;
    
    return CGPointMake(tx, ty);
}

- (void)setTime:(NSUInteger)time{
    self.currentTime = time;
    [self timeToCoordinate];
    [self setTimerPosition];
}

- (void)timerUp{
    
    if(self.currentTime >= 1){
        self.currentTime -= 1;
        [self setTimerPosition];
    }
    if(self.currentTime == 0){
        if([self.delegate respondsToSelector:@selector(willTimerEnd:)]  && self.timerActive){
            [self startTimer:NO];
            [self.delegate willTimerEnd:self];
        }
    }
}

- (void)stopTimer{
    self.currentAngle = startAngleCircle;
    [self setTimerPosition];
}

- (void)startTimer:(BOOL)start{
    
    self.startTime = self.currentTime;
    self.timerActive = start;
    if(start){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                      target:self
                                                    selector:@selector(timerUp)
                                                    userInfo:nil
                                                     repeats:start];
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
    
}

#pragma mark - Style

- (void)setStylePin:(KVStyle *)style{
    self.pinStyle = style;
}

- (void)setStyleLine:(KVStyle *)style{
    self.lineStyle = style;
}

- (void)setStyleCircle:(KVStyle *)style{
    self.circleStyle = style;
}


#pragma mark - UILabel

- (void)showLabelTime{
    if(!self.timeLabel){
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.font=[UIFont systemFontOfSize:self.lineStyle.radius / 2 weight:UIFontWeightThin];
        [self.timeLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:self.timeLabel];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%li", (long)self.currentTime];
}

- (void)showLabelKof{
    if(!self.kofLabel){
        self.kofLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2+self.lineStyle.radius/3, self.frame.size.width, self.lineStyle.radius/3)];
        self.kofLabel.textAlignment = NSTextAlignmentCenter;
        self.kofLabel.font=[UIFont systemFontOfSize:self.lineStyle.radius/3 weight:UIFontWeightThin];
        [self.kofLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:self.kofLabel];
    }
    self.kofLabel.text = self.kofString;
}

#pragma mark - Time

- (void)setMaxTime:(NSInteger)max minTime:(NSInteger)min{
    self.timeMin = min>max ? 0 : min;
    self.timeMax = 360.0f / max;
}

#pragma mark - Gesture

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender{
    CGPoint translation = sender ? [sender locationInView:self] : [self timeToCoordinate];
    
    CGFloat angleInRadians = atan2f(translation.y - self.frame.size.height/2, translation.x - self.frame.size.width/2);
    float angle = angleInRadians + M_PI / 180;
    self.currentAngle = angle+(coefficient*6);
    [self setTimerPosition];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return !self.timerActive;
}

@end
