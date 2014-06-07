//
//  Component+ObjectMapping.m
//  ah3q
//
//  Created by Ethan Nguyen on 11/16/13.
//  Copyright (c) 2013 Vinova. All rights reserved.
//

#import "NSObject+ObjectMapping.h"
#import "objc/runtime.h"

//#undef DEBUG

#define kParamClassName       @"className"

@implementation NSObject (ObjectMapping)

- (void)assignProperties:(NSDictionary *)dict {
  for (NSString *key in dict) {
    NSObject *value = [dict valueForKey:key];
    
    NSString *name = [NSObject convertToCamelCaseFromSnakeCase:key capitalizeFirstLetter:NO];
    
    objc_property_t property =
    class_getProperty([self class], [name cStringUsingEncoding:NSUTF8StringEncoding]);
    if (property == NULL) {
#ifdef DEBUG
      NSLog(@"no property for key %@", key);
#endif
      continue;
    }
    
    NSString *attributesString = [NSString stringWithUTF8String: property_getAttributes(property)];
    NSString *typeString = [[[attributesString componentsSeparatedByString:@","] objectAtIndex:0] substringFromIndex:1];
    
    if ([typeString length] == 1 && [@"cdifls" rangeOfString:[typeString lowercaseString]].location != NSNotFound) {
      if ([value isKindOfClass:[NSNumber class]])
        [self setValue:value forKey:name];
#ifdef DEBUG
      else
        NSLog(@"property %@ does not match type %@", name, [value class]);
#endif
      continue;
    }
    
    if ([typeString rangeOfString:@"@"].location == NSNotFound) {
#ifdef DEBUG
      NSLog(@"unknown type %@", typeString);
      continue;
#endif
    }
    
    NSError *error = NULL;
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:@"@\"(.+)\""
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];
    NSArray *matches = [regex matchesInString:typeString
                                      options:0
                                        range:NSMakeRange(0, [typeString length])];
    
    if ([matches count] == 0) {
#ifdef DEBUG
      NSLog(@"unknown type %@", typeString);
#endif
      continue;
    }
    
    NSTextCheckingResult *match = [matches objectAtIndex:0];
    NSString *className = [typeString substringWithRange:[match rangeAtIndex:1]];
    Class aClass = NSClassFromString(className);
    
    if ([value isKindOfClass:[NSNull class]]) {
#ifdef DEBUG
      NSLog(@"do not set null value for property %@", name);
#endif
    } else if ([value isKindOfClass:NSClassFromString(className)])
      [self setValue:value forKey:name];
    else if (class_respondsToSelector(aClass, @selector(assignProperties:)) &&
             [value isKindOfClass:[NSDictionary class]]) {
      // Recursive
      id subObject = [[aClass alloc] init];
      [subObject assignProperties:(NSDictionary *)value];
      [self setValue:subObject forKey:name];
    }
#ifdef DEBUG
    else
      NSLog(@"property %@ has type %@, while value has type %@",
            name, className, [value class]);
#endif
  }
}

- (void)assignPropertiesFromDict:(NSDictionary *)dict forParams:(NSArray *)params {
  for (NSString *param in params)
    if (dict[param] != nil && ![dict[param] isKindOfClass:[NSNull class]])
      [self setValue:dict[param] forKey:[NSObject convertToCamelCaseFromSnakeCase:param]];
}

+ (NSArray *)mappingParams {
  return @[];
}

+ (NSString *)convertToCamelCaseFromSnakeCase:(NSString *)snakeCase {
  return [NSObject convertToCamelCaseFromSnakeCase:snakeCase capitalizeFirstLetter:NO];
}

+ (NSString *)convertToCamelCaseFromSnakeCase:(NSString *)snakeCase capitalizeFirstLetter:(BOOL)capitalize {
  NSString *snakeCaseToConvert = snakeCase;
  
  if ([snakeCaseToConvert isEqualToString:@"_id"] || [snakeCaseToConvert isEqualToString:@"id"])
    snakeCaseToConvert = @"Id";
  
  if ([snakeCaseToConvert isEqualToString:@"description"])
    snakeCaseToConvert = @"Description";
  
  NSArray *snakeCaseComponents = [snakeCaseToConvert componentsSeparatedByString:@"_"];
  NSMutableArray *camelCaseComponents = [NSMutableArray array];
  
  [snakeCaseComponents enumerateObjectsUsingBlock:^(NSString *string, NSUInteger index, BOOL *stop) {
    NSString *stringToAdd = (index == 0 && !capitalize) ? string : [string capitalizedString];
    [camelCaseComponents addObject:stringToAdd];
  }];
  
  return [camelCaseComponents componentsJoinedByString:@""];
}

+ (NSDictionary *)convertDictionaryToParameterizedDictionary:(NSDictionary *)dictionary {
  return [NSObject convertDictionaryToParameterizedDictionary:dictionary insertedClassName:nil];
}

+ (NSDictionary *)convertDictionaryToParameterizedDictionary:(NSDictionary *)dictionary
                                           insertedClassName:(NSString *)className {
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  
  for (NSString *key in dictionary) {
    NSObject *value = dictionary[key];
    
    if ([value isKindOfClass:[NSDictionary class]])
      value = [NSObject convertDictionaryToParameterizedDictionary:(NSDictionary *)value insertedClassName:nil];
    if ([value isKindOfClass:[NSArray class]]) {
      NSMutableArray *parameterized = [NSMutableArray array];
      
      for (NSDictionary *valueDict in (NSArray *)value) {
        if ([valueDict isKindOfClass:[NSDictionary class]])
          [parameterized addObject:[NSObject convertDictionaryToParameterizedDictionary:valueDict insertedClassName:nil]];
        else
          [parameterized addObject:valueDict];
      }
      
      value = parameterized;
    }
      
    dict[[NSObject convertToCamelCaseFromSnakeCase:key]] = value;
  }
  
  if (className != nil && [className isKindOfClass:[NSString class]])
    dict[kParamClassName] = className;
  
  return dict;
}

//#ifndef DEBUG
//#define DEBUG
//#endif

@end
