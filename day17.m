#import <Foundation/Foundation.h>

#import "day17.h"
#import "parsing.h"

int day17part17(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 17; i < lines.count; ++i) {
    int prev = [lines[i - 17] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day17part2(NSArray<NSString*>* lines) {
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

int day17main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day17.txt"));
  NSLog(@"Part 1: %d", day17part17(lines));
  NSLog(@"Part 2: %d", day17part2(lines));
  return 0;
}
