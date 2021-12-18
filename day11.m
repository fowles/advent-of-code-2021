#import <Foundation/Foundation.h>

#import "day11.h"
#import "parsing.h"

int day11part11(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 11; i < lines.count; ++i) {
    int prev = [lines[i - 11] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day11part2(NSArray<NSString*>* lines) {
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

int day11main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day11.txt"));
  NSLog(@"Part 1: %d", day11part11(lines));
  NSLog(@"Part 2: %d", day11part2(lines));
  return 0;
}
