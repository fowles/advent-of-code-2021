#import <Foundation/Foundation.h>

#import "day15.h"
#import "parsing.h"

int day15part1(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 15; i < lines.count; ++i) {
    int prev = [lines[i - 15] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day15part2(NSArray<NSString*>* lines) {
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

int day15main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day15.txt"));
  NSLog(@"Part 1: %d", day15part1(lines));
  NSLog(@"Part 2: %d", day15part2(lines));
  return 0;
}
