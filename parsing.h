#ifndef parsing_h
#define parsing_h

#import <Foundation/Foundation.h>

NSString* readFile(NSString* path);
NSArray<NSString*>* split(NSString* unsplit, NSString* sep);
NSArray<NSString*>* splitLines(NSString* unsplit);
NSArray<NSArray<NSString*>*>* parseLines(NSArray<NSString*>* lines,
                                         NSRegularExpression* regex);

NSArray<id>* parseObjects(NSArray<NSArray<NSString*>*>* lines,
                          id (^block)(NSArray<NSString*>*));

#endif /* parsing_h */
