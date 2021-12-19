#import <Foundation/Foundation.h>

#import "day12.h"
#import "parsing.h"

int day12part1(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 12; i < lines.count; ++i) {
    int prev = [lines[i - 12] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day12part2(NSArray<NSString*>* lines) {
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

int day12main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day12.txt"));
  NSLog(@"Part 1: %d", day12part1(lines));
  NSLog(@"Part 2: %d", day12part2(lines));
  return 0;
}
