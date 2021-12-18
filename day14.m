#import <Foundation/Foundation.h>

#import "day14.h"
#import "parsing.h"

int day14part14(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 14; i < lines.count; ++i) {
    int prev = [lines[i - 14] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day14part2(NSArray<NSString*>* lines) {
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

int day14main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day14.txt"));
  NSLog(@"Part 1: %d", day14part14(lines));
  NSLog(@"Part 2: %d", day14part2(lines));
  return 0;
}
