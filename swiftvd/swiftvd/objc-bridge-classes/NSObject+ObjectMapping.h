//
//  Component+ObjectMapping.h
//  ah3q
//
//  Created by Ethan Nguyen on 11/16/13.
//  Copyright (c) 2013 Vinova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ObjectMapping)

- (void)assignProperties:(NSDictionary *)dict;
- (void)assignPropertiesFromDict:(NSDictionary *)dict forParams:(NSArray *)params;
+ (NSArray *)mappingParams;

+ (NSString *)convertToCamelCaseFromSnakeCase:(NSString *)snakeCase;
+ (NSString *)convertToCamelCaseFromSnakeCase:(NSString *)snakeCase capitalizeFirstLetter:(BOOL)capitalize;

+ (NSDictionary *)convertDictionaryToParameterizedDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)convertDictionaryToParameterizedDictionary:(NSDictionary *)dictionary
                                           insertedClassName:(NSString *)className;

@end
