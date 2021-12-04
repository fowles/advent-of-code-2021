#import <Foundation/Foundation.h>

#import "day3.h"
#import "parsing.h"

NSUInteger day3part1(NSArray<NSString*>* lines) {
  NSUInteger gamma = 0;
  NSUInteger epsilon = 0;

  NSUInteger len = lines[0].length;
  for (NSUInteger pos = 0; pos < len; ++pos) {
    int ones = 0;
    for (id line in lines) {
      if ([line characterAtIndex:pos] == '1') {
        ++ones;
      }
    }

    if (ones > lines.count/2) {
      gamma |= 1 << (len - 1 - pos);
    } else {
      epsilon |= 1 << (len - 1 - pos);
    }
  }
  return gamma * epsilon;
}

int day3main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day3.txt"));
  NSLog(@"Part 1: %lu", day3part1(lines));
  return 0;
}
