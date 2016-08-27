//
//  WetherAPI.m
//  curtainWhetherApp
//
//  Created by WatanabeYoichiro on 2016/02/13.
//  Copyright © 2016年 YoichiroWatanabe. All rights reserved.
//

#import "WetherAPI.h"

@implementation WetherAPI

-(NSArray *) getWetherState
{
    NSURL *openWetherURL = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?q=Tokyo&APPID=a71f77b53f68fbe5c78e63aaa19a338d"];
    NSError * error = nil;
    NSData *wetherJsonData = [NSData dataWithContentsOfURL:openWetherURL options:kNilOptions error:&error];
    NSArray *wetherJsonResponse = [NSJSONSerialization JSONObjectWithData:wetherJsonData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"%@", wetherJsonResponse);
    NSString *city = [wetherJsonResponse valueForKeyPath:@"name"];
    NSArray *condition = [wetherJsonResponse valueForKeyPath:@"weather.main"];
    NSArray *conditionId = [wetherJsonResponse valueForKeyPath:@"weather.id"];
    NSLog(@"%@", city);
    NSLog(@"%@", condition[0]);
    NSArray *weatherConditionArray = @[city, condition[0], conditionId[0]];
    return weatherConditionArray;
}

@end
