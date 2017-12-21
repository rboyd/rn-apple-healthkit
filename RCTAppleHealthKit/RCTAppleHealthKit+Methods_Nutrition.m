//
//  RCTAppleHealthKit+Methods_Fitness.m
//  RCTAppleHealthKit
//

#import "RCTAppleHealthKit+Methods_Nutrition.h"
#import "RCTAppleHealthKit+Queries.h"
#import "RCTAppleHealthKit+Utils.h"

#import <RCTBridgeModule.h>
#import <React/Base/RCTEventDispatcher.h>

@implementation RCTAppleHealthKit (Methods_Nutrition)


- (void)nutrition_getDailyDietarySamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    NSString *hkTypeString = input[@"typeName"];
    NSArray *items = @[@"DietaryCarbohydrates", @"DietaryFatTotal", @"DietaryProtein",
			@"DietarySodium", @"DietaryFiber"];
    int item = [items indexOfObject:hkTypeString];
    HKQuantityTypeIdentifier targetType;
    HKUnit *unit = [RCTAppleHealthKit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit gramUnit]];
    switch (item) {
    case 0:
      targetType = HKQuantityTypeIdentifierDietaryCarbohydrates;
      break;
    case 1:
      targetType = HKQuantityTypeIdentifierDietaryFatTotal;
      break;
    case 2:
      targetType = HKQuantityTypeIdentifierDietaryProtein;
      break;
    case 3:
      targetType = HKQuantityTypeIdentifierDietarySodium;
      unit = [RCTAppleHealthKit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit gramUnitWithMetricPrefix:HKMetricPrefixMilli]];
      break;
    case 4:
      targetType = HKQuantityTypeIdentifierDietaryFiber;
      break;
    }



    //    HKUnit *unit = [RCTAppleHealthKit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit gramUnit]];
    NSUInteger limit = [RCTAppleHealthKit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RCTAppleHealthKit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RCTAppleHealthKit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RCTAppleHealthKit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
        return;
    }

    HKQuantityType *dietaryCarbohydratesType = [HKObjectType quantityTypeForIdentifier:targetType];

    [self fetchCumulativeSumStatisticsCollection:dietaryCarbohydratesType
                                            unit:unit
                                       startDate:startDate
                                         endDate:endDate
                                       ascending:ascending
                                           limit:limit
                                      completion:^(NSArray *arr, NSError *err){
        if (err != nil) {
            NSLog(@"error with fetchCumulativeSumStatisticsCollection: %@", err);
            callback(@[RCTMakeError(@"error with fetchCumulativeSumStatisticsCollection", err, nil)]);
            return;
        }
        callback(@[[NSNull null], arr]);
    }];
}


@end
