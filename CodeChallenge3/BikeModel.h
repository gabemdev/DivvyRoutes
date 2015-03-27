//
//  BikeModel.h
//  CodeChallenge3
//
//  Created by Rockstar. on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BikeModel : MKPointAnnotation

@property NSNumber *availableBikes;
@property NSNumber *availableDocks;
@property NSNumber *totalDocks;
@property NSNumber *stationID;
@property NSString *city;
@property NSString *landmark;
@property NSString *location;
@property NSString *streetAddress;
@property NSString *stationName;
@property NSString *status;
@property CLLocationDistance distance;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andLocation:(CLLocation *)location;





@end
