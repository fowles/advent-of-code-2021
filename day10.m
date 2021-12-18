#import <Foundation/Foundation.h>

#import "day10.h"
#import "parsing.h"

int day10part1(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 10; i < lines.count; ++i) {
    int prev = [lines[i - 10] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day10part2(NSArray<NSString*>* lines) {
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

int day10main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day10.txt"));
  NSLog(@"Part 10: %d", day10part1(lines));
  NSLog(@"Part 2: %d", day10part2(lines));
  return 0;
}
