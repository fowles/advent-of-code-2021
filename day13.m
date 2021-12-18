#import <Foundation/Foundation.h>

#import "day13.h"
#import "parsing.h"

int day13part13(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 13; i < lines.count; ++i) {
    int prev = [lines[i - 13] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day13part2(NSArray<NSString*>* lines) {
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

int day13main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day13.txt"));
  NSLog(@"Part 1: %d", day13part13(lines));
  NSLog(@"Part 2: %d", day13part2(lines));
  return 0;
}
