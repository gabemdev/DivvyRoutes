//
//  CustomTableViewCell.h
//  CodeChallenge3
//
//  Created by Rockstar. on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceStation;
@property (weak, nonatomic) IBOutlet UILabel *statusStation;
@property (weak, nonatomic) IBOutlet UILabel *bikesAvailableLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationNumber;

@end
