//
//  Score.h
//  FinalProject
//
//  Created by Hunter Houston on 5/9/14.
//  Copyright (c) 2014 CONNER KNUTSON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Score : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * score;

@end
