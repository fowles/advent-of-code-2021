//
//  day1.m
//  aoc-2021
//
//  Created by Beaker Kulukundis on 12/4/21.
//

#import <Foundation/Foundation.h>

#import "day1.h"

NSString* readFile(NSString* path) {
  return [[NSString stringWithContentsOfFile:@"input/day1.txt"
                                    encoding:NSUTF8StringEncoding
                                       error:NULL]
      stringByTrimmingCharactersInSet:NSCharacterSet
                                          .whitespaceAndNewlineCharacterSet];
}

NSArray *splitLines(NSString *s) { return [s componentsSeparatedByString:@"\n"]; }

int part1(NSArray *lines) {
  int increasing = 0;
  for (int i = 1; i < lines.count; ++i) {
    int prev = [lines[i - 1] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int part2(NSArray *lines) {
  int increasing = 0;
  for (int i = 3; i < lines.count; ++i) {
    int prev = [lines[i - 3] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}
