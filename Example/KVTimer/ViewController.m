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

@property (strong, nonatomic) IBOutletCollection(KVTimer) NSArray<KVTimer*> *timers;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for(int i = 0; i < self.timers.count; i++){
        [self.timers[i] setDelegate:self];
        [self.timers[i] setShowTimerLabel:YES];
        [self.timers[i] setShowKofLabel:YES];
        [self.timers[i] setMaxTime:120 minTime:5];
        switch (i) {
            case 0:{
                [self.timers[i] setInterval:KVIntervalHour];
                [self.timers[i] setKofString:@"Hour"];
            };
                break;
            case 1:{
                [self.timers[i] setInterval:KVIntervalMinute];
                [self.timers[i] setKofString:@"Min"];
            };
                break;
            case 2:{
                [self.timers[i] setInterval:KVIntervalSecond];
                [self.timers[i] setKofString:@"Second"];
            };
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - KVTimer delegate

- (void)KVTimer:(KVTimer *)timer willTimeChange:(NSString *)newTime{
    NSLog(@"Time: %@", newTime);
}

- (void)willTimerEnd:(KVTimer *)timer{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"KVTimer"
                                                                   message:@"GAME OVER :)"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Action

- (IBAction)startOrStop:(UIButton *)sender {
    static BOOL start;
    start = !start;
    for(KVTimer *timer in self.timers){
        [timer startTimer:start];
    }
}

@end
