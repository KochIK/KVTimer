//
//  Created by Vlad Kochergin on 11.08.16.
//  Copyright © 2016 All rights reserved.
//


#import "KVTimer.h"

@interface KVTimer ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) CAShapeLayer *circle;
@property (strong, nonatomic) CAShapeLayer *pin;
@property (strong, nonatomic) CAShapeLayer *baseCircle;

@property (nonatomic) float currentAngle;
@property (nonatomic) NSInteger currentTime;
@property (nonatomic) NSInteger startTime;

@property (nonatomic) NSUInteger TimeMin;
@property (nonatomic) CGFloat TimeMax;

@property (nonatomic) BOOL timerActive;

@property (nonatomic, strong) UIColor *pinColor;
@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) KVStyle *pinStyle;
@property (nonatomic, strong) KVStyle *circleStyle;
@property (nonatomic, strong) KVStyle *lineStyle;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *kofLabel;


@end

#define R MIN(self.frame.size.height/2, self.frame.size.width/2) //Radius
#define dR 10 //default radius
#define k 0.070833
#define endAngleCircle 10
#define startAngleCircle -1.5
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

//0.09583333;//0.070833;


@implementation KVTimer

#pragma mark - Getters

- (NSInteger)currentTime{
    if(!_currentTime)
        return _TimeMin;
    return _currentTime+self.TimeMin;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
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
    if ((self = [super initWithCoder:aDecoder])) {
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

- (void)setupView{
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.pinStyle = !self.pinStyle ? [KVStyle initWithFillColor:[UIColor whiteColor] strokeColor:[UIColor clearColor] lineWidth:2 radius:dR] : self.pinStyle;
    self.circleStyle = !self.circleStyle ? [KVStyle initWithFillColor:[UIColor clearColor] strokeColor:[UIColor colorWithWhite:1.0 alpha:0.3] lineWidth:2 radius:R] : self.circleStyle;
    self.lineStyle = !self.lineStyle ? [KVStyle initWithFillColor:[UIColor clearColor] strokeColor:[UIColor whiteColor] lineWidth:2 radius:R] : self.lineStyle;
    self.TimeMin = !self.TimeMin ? 0 : self.TimeMin;
    self.TimeMax = !self.TimeMax ? 60 : self.TimeMax;
    self.interval = !self.interval ? KVIntervalSecond : self.interval;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupView];
    [self panGestureRecognized:nil];
}

/*-(void)forwardGesture:(UIPanGestureRecognizer *)sender{
 [self panGestureRecognized:sender];
 }
 */
- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = sender ? [sender locationInView:self] : CGPointMake(243, 71);
    if(!sender){
        
        [self.baseCircle removeFromSuperlayer];
        self.baseCircle = [CAShapeLayer new];
        
        self.baseCircle.path = [UIBezierPath bezierPathWithArcCenter:
                                CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
                                                              radius:self.circleStyle.radius
                                                          startAngle:0
                                                            endAngle:endAngleCircle clockwise:YES].CGPath;
        
        self.baseCircle.fillColor = self.circleStyle.fillColor.CGColor;
        self.baseCircle.strokeColor = self.circleStyle.strokeColor.CGColor;
        self.baseCircle.lineWidth = self.circleStyle.lineWidth;
        
        [self.layer addSublayer:self.baseCircle];
        
    }
    CGFloat angleInRadians = atan2f(translation.y - self.frame.size.height/2, translation.x - self.frame.size.width/2);
    float angle = angleInRadians + M_PI / 180;
    self.currentAngle = angle+(k*6);
    [self setTimerWithPosition];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return !self.timerActive;
}

- (void)setTimerWithPosition{
    
    
    CGPoint position = [self handePosition];
    
    if(self.timerActive){
        if(self.currentTime >= 0){
            position = [self timeToCoordinate];
        }
    }else{
        NSInteger minutesFloat =(atan2f(position.x - self.frame.size.width / 2, position.y - self.frame.size.height / 2) * -(180 / M_PI) + 180)/self.TimeMax;
        self.currentTime = minutesFloat;
    }
    
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
    
    if([self.delegate respondsToSelector:@selector(getTimer:)]){
        [self.delegate performSelector:@selector(getTimer:) withObject:[NSString stringWithFormat:@"%li", (long)self.currentTime]];
    }
}

- (CGPoint)handePosition{
    
    double tx = self.circleStyle.radius*cosf(self.currentAngle) + self.frame.size.width / 2;
    double ty = self.circleStyle.radius*sinf(self.currentAngle) + self.frame.size.height / 2;
    
    return CGPointMake(tx, ty);
}

- (CGPoint)timeToCoordinate{
    
    float alpha=90-360 / (360 / self.TimeMax)*self.currentTime;
    float tx= self.frame.size.width / 2 + self.circleStyle.radius*cos(DEGREES_TO_RADIANS(alpha));
    float ty= self.frame.size.height / 2 + -self.circleStyle.radius*sin(DEGREES_TO_RADIANS(alpha));
    
    CGFloat angleInRadians = atan2f(ty - self.frame.size.height / 2, tx - self.frame.size.width / 2);
    
    float angle = angleInRadians + M_PI / 180;
    self.currentAngle = angle;
    
    return CGPointMake(tx, ty);
}

- (void)timerUp{
    
    if(self.currentTime >= 1){
        self.currentTime -= 1+self.TimeMin;
        [self setTimerWithPosition];
    }
    if(self.currentTime == 0){
        if([self.delegate respondsToSelector:@selector(endTime)]  && self.timerActive){
            [self startTimer:NO];
            [self.delegate performSelector:@selector(endTime)];
        }
    }
}

- (void)stopTimer{
    self.currentAngle = startAngleCircle;
    [self setTimerWithPosition];
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
    }else{
        [self.timer invalidate];
        self.timer = nil;
    }
    
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
    self.TimeMin = min>max ? 0 : min;
    self.TimeMax = 360.0f / (max-min);
}

@end