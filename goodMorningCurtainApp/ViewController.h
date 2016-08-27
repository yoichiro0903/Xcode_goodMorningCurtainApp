//
//  ViewController.h
//  curtainWhetherApp
//
//  Created by WatanabeYoichiro on 2016/02/13.
//  Copyright © 2016年 YoichiroWatanabe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothConnection.h"
#import "WetherAPI.h"

@interface ViewController : UIViewController <bluetoothNotificationDelegate, UITextFieldDelegate>

@property(nonatomic) BluetoothConnection *BTConnection;
@property(nonatomic) WetherAPI *wetherState;
@property (weak, nonatomic) IBOutlet UILabel *consoleText;
@property (weak, nonatomic) IBOutlet UISwitch *BTScanSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *Scratch1Control;


@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

@end

