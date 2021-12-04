#import <Foundation/Foundation.h>

#import "day1.h"
#import "parsing.h"

int day1part1(NSArray<NSString*>* lines) {
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

int day1part2(NSArray<NSString*>* lines) {
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

int day1main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day1.txt"));
  NSLog(@"Part 1: %d", day1part1(lines));
  NSLog(@"Part 2: %d", day1part2(lines));
  return 0;
}
