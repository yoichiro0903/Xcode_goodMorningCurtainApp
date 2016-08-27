//
//  ViewController.m
//  curtainWhetherApp
//
//  Created by WatanabeYoichiro on 2016/02/13.
//  Copyright © 2016年 YoichiroWatanabe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.consoleText.text = [self.consoleText.text stringByAppendingString:@"\nViewDidLoad\n"];
//    _BTConnection = [[BluetoothConnection alloc] init];
    _BTConnection = [BluetoothConnection sharedManager];
    
    //デリゲートプロパティをself（ViewControllerクラス）に設定。
    //なんかこれはお約束で覚えておくのが良いのかな。
    _BTConnection.BTNotification = self;
    
    //天気情報を取るためのインスタンスを生成。
    _wetherState = [[WetherAPI alloc] init];
    
//////////////////
    //デートピッカーのインスタンス作成初期化
    UIDatePicker *datePicker= [[UIDatePicker alloc]init];
    //デートピッカーのモードを設定
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    //テキストフィールドの入力をデートピッカーに変更
    _timeTextField.inputView = datePicker;
    
    
    //ピッカーの値が変更された時に呼ばれるメソッドを設定
    [datePicker addTarget:self action:@selector(datePicker_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //テキスト入力のキーボードに閉じるボタンを付ける
    UIView* accessoryView =[[UIView alloc] initWithFrame:CGRectMake(0,0,320,50)];
    accessoryView.backgroundColor = [UIColor clearColor];
    
    // ボタンを作成する。
    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(self.view.frame.size.width-120,10,100,30);
    [closeButton setTitle:@"閉じる" forState:UIControlStateNormal];
    
    // ボタンを押したときによばれる動作を設定する。
    [closeButton addTarget:self action:@selector(closeKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    
    // ボタンをViewに貼る
    [accessoryView addSubview:closeButton];
    
    //ボタンを適用するテキストフィールドに設定
    _timeTextField.inputAccessoryView = accessoryView;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startBTScanning:(id)sender
{
    if (_BTScanSwitch.on == YES) {
        [_BTConnection startScanning];
    } else {
        [_BTConnection disconnectIntrinsic];
    }
}

- (IBAction)Scratch1ControllSegment:(id)sender
{
    NSInteger state;
    if (_Scratch1Control.selectedSegmentIndex <= 3) {
        state = _Scratch1Control.selectedSegmentIndex;
        [_BTConnection changeScratch1Characteristics:&state];
    } else if (_Scratch1Control.selectedSegmentIndex == 4) { //Get Weather data.
        NSArray *weatherData = [_wetherState getWetherState];
        NSLog(@"viewController %@",weatherData);
        NSString *weatherStatement = [NSString stringWithFormat:@"%@ is in %@ now\n",weatherData[0],weatherData[1]];
        self.consoleText.text = [self.consoleText.text stringByAppendingString:weatherStatement];
        if ([weatherData[2] intValue] < 800) { //Rain
            NSLog(@"%d", [weatherData[2] intValue]);
            //Light up Bean's LED on Blue
            state = 3;
            [_BTConnection changeScratch1Characteristics:&state];
        } else if ([weatherData[2] intValue] >= 800) { //Sunny
            NSLog(@"%d", [weatherData[2] intValue]);
            //Light up Bean's LED on Red
            state = 1;
            [_BTConnection changeScratch1Characteristics:&state];
        }
    }
}

-(void)BTStateMassageSend:(NSString *)scanningState
{
    NSLog(@"%s", "Here is ViewController.m. Executed BTStateMassageSend");
    scanningState = [scanningState stringByAppendingString:@"\n"];
    self.consoleText.text = [self.consoleText.text stringByAppendingString:scanningState];
}

//キーボードを閉じる
-(void)closeKeyboard:(id)sender
{
    [self.timeTextField resignFirstResponder];
}

//ピッカーの値を反映
- (void)datePicker_ValueChanged:(id)sender
{
    UIDatePicker *datePicker = sender;
    
    // 日付の表示形式を設定
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy/MM/dd HH:mm";
    
    self.timeTextField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
    NSLog(@"%@", [df stringFromDate:datePicker.date]);
}

@end
