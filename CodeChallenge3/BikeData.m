//
//  BikeData.m
//  CodeChallenge3
//
//  Created by Rockstar. on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "BikeData.h"
#import "BikeModel.h"

#define API @"http://www.divvybikes.com/stations/json"

@implementation BikeData

- (void)getBikeStationLocation:(CLLocation *)location {
    NSURL *url = [NSURL URLWithString:API];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *bikeDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

        NSArray *bikeStationArray = bikeDictionary[@"stationBeanList"];
        NSMutableArray *bikeStationMutableArray = [NSMutableArray new];
        for (NSDictionary *stationDict in bikeStationArray) {
            BikeModel *station = [[BikeModel alloc] initWithDictionary:stationDict andLocation:location];
            [bikeStationMutableArray addObject:station];
        }
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
        NSArray *sortArray = [bikeStationMutableArray sortedArrayUsingDescriptors:@[descriptor]];

        [self.delegate didGetArrayOfBikeResults:[[NSArray arrayWithArray:sortArray]mutableCopy]];
    }];
}

@end
