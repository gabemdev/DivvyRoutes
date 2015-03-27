//
//  BikeData.h
//  CodeChallenge3
//
//  Created by Rockstar. on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@protocol BikeDataDelegate <NSObject>

- (void)didGetArrayOfBikeResults:(NSMutableArray *)stops;

@end

@interface BikeData : NSObject
@property (nonatomic, assign) id<BikeDataDelegate>delegate;

- (void)getBikeStationLocation:(CLLocation *)location;


@end
