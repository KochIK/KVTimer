//
//  ViewController.m
//  KVTimer
//
//  Created by Pinta WebWare on 05.09.16.
//  Copyright © 2016 Vlad Kochergin. All rights reserved.
//

#import "ViewController.h"
#import "KVTimer.h"

@interface ViewController ()<KVTimerDelegate>

@property (weak, nonatomic) IBOutlet KVTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timer.delegate = self;
    [self.timer setShowTimerLabel:YES];
    [self.timer setMaxTime:120 minTime:0];
    self.timer.interval = KVIntervalSecond;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - KVTimer delegate

- (void)getTimer:(NSString *)time{
    NSLog(@"Time: %@", time);
}

- (void)endTime{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"KVTimer"
                                                                     message:@"GAME OVER :)"
                                                preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)startOrStop:(UIButton *)sender {
    static BOOL start;
    start = !start;
    [self.timer startTimer:start];
}
@end
