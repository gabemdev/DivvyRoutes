//
//  BikeModel.m
//  CodeChallenge3
//
//  Created by Rockstar. on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "BikeModel.h"

@implementation BikeModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andLocation:(CLLocation *)location {
    if (self = [super init]) {
        self.availableBikes = dictionary[@"availableBikes"];
        self.availableDocks = dictionary[@"availableDocks"];
        self.totalDocks = dictionary[@"totalDocks"];
        self.city = dictionary[@"city"];
        self.stationID = dictionary[@"id"];
        self.landmark = dictionary[@"landMark"];
        self.location = dictionary[@"location"];
        self.streetAddress = dictionary[@"stAddress1"];
        self.stationName = dictionary[@"stationName"];
        self.status = dictionary[@"statusValue"];

        self.title = dictionary[@"stAddress1"];
        self.subtitle = dictionary[@"statusValue"];
        self.coordinate = CLLocationCoordinate2DMake([dictionary[@"latitude"] doubleValue], [dictionary[@"longitude"] doubleValue]);
        CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
        self.distance = [stationLocation distanceFromLocation:location];
    }
    return self;
}
@end
