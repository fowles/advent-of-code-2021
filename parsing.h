#ifndef parsing_h
#define parsing_h

#import <Foundation/Foundation.h>

NSString* readFile(NSString* path);
NSArray<NSString*>* splitLines(NSString* s);
NSArray<NSArray<NSString*>*>* parseLines(NSArray<NSString*>* s,
                                         NSRegularExpression* regex);

#endif /* parsing_h */
