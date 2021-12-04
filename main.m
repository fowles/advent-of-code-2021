//
//  main.m
//  aoc-2021
//
//  Created by Beaker Kulukundis on 12/3/21.
//

#import <Foundation/Foundation.h>
#import "day1.h"

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    id lines = splitLines(readFile(@"input/day1.txt"));
    NSLog(@"Part 1: %d", part1(lines));
    NSLog(@"Part 2: %d", part2(lines));
  }
  return 0;
}
