#import <Foundation/Foundation.h>

#import "day16.h"
#import "parsing.h"

int day16part1(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 16; i < lines.count; ++i) {
    int prev = [lines[i - 16] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day16part2(NSArray<NSString*>* lines) {
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

int day16main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day16.txt"));
  NSLog(@"Part 1: %d", day16part1(lines));
  NSLog(@"Part 2: %d", day16part2(lines));
  return 0;
}
