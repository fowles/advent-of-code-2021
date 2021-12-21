#ifndef parsing_h
#define parsing_h

#import <Foundation/Foundation.h>

NSString* readFile(NSString* path);
NSArray<NSString*>* split(NSString* unsplit, NSString* sep);
NSArray<NSString*>* splitLines(NSString* unsplit);
NSArray<NSString*>* parseLine(NSString* lines, NSRegularExpression* regex);
NSArray<NSArray<NSString*>*>* parseLines(NSArray<NSString*>* lines,
                                         NSRegularExpression* regex);

NSArray<id>* parseObjects(NSArray<NSArray<NSString*>*>* lines,
                          id (^block)(NSArray<NSString*>*));

#define SWAP(type, a_, b_) \
  do { \
        struct { type *a; type *b; type t; } SWAP; \
        SWAP.a  = &(a_); \
        SWAP.b  = &(b_); \
        SWAP.t  = *SWAP.a; \
        *SWAP.a = *SWAP.b; \
        *SWAP.b =  SWAP.t; \
  } while (0)

#endif /* parsing_h */
