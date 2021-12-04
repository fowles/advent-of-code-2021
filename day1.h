//
//  day1.h
//  aoc-2021
//
//  Created by Beaker Kulukundis on 12/4/21.
//

#ifndef day1_h
#define day1_h

#import <Foundation/Foundation.h>

NSString *readFile(NSString *path);
NSArray *splitLines(NSString *s);

int part1(NSArray *lines);
int part2(NSArray *lines);

#endif /* day1_h */
