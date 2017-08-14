# KVTimer
The circular timer for iOS - KVTimer

![](http://s21.postimg.org/jq6kq4t87/ezgif_com_video_to_gif_3.gif)
    
    
## Installation
    
### Using CocoaPods

 KVTimer is available through [CocoaPods](http://cocoapods.org), to install 
 it simply add the following line to your Podfile:
 
    pod "KVTimer"
 
### Manual
 
  Download the project and add the files `KVTimer.{h,m}` to your project.
  
## Usage

  ![](https://s10.postimg.org/xs26od095/ezgif_com_video_to_gif_2.gif)
 
    /*Create its Outlet -*/ @property (weak, nonatomic) IBOutlet KVTimer *timer;
  
     self.timer.delegate = self;
     [self.timer setShowTimerLabel:YES];
     [self.timer setMaxTime:120 minTime:0];
     self.timer.interval = KVIntervalSecond;

    KVStyle *style = [KVStyle initWithFillColor:[UIColor greenColor]
                                    strokeColor:[UIColor blackColor]
                                      lineWidth:2 
                                        radius:10];
                      
     [self.timer setStylePin:<#(KVStyle *)#>]
     [self.timer setStyleLine:<#(KVStyle *)#>]
     [self.timer setStyleCircle:<#(KVStyle *)#>]
  
     [self.timer startTimer:/* YES / NO */];
     [self.timer setShowTimerLabel:/* YES / NO*/];
     [self.timer setShowKofLabel:/* YES / NO*/];
     [self.timer setKofString:@"min"];
     [self.timer setInterval:KVIntervalMinute /*(KVInterval enum)*/];
     
### Method delegate:

    - (void)KVTimer:(KVTimer *)timer willTimeChange:(NSString *)newTime{
       NSLog(@"Time: %@", newTime);
    }
    
    - (void)willTimerEnd:(KVTimer *)timer{
       NSLog(@"Oops");
    }

## Author

 Vlad Kochergin, kargod@ya.ru
 
## License
 
 KVTimer is available under the MIT license. See the LICENSE file for more info.
 
