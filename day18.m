#import <Foundation/Foundation.h>

#import "day18.h"
#import "parsing.h"

int day18part18(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 18; i < lines.count; ++i) {
    int prev = [lines[i - 18] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day18part2(NSArray<NSString*>* lines) {
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

int day18main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day18.txt"));
  NSLog(@"Part 1: %d", day18part18(lines));
  NSLog(@"Part 2: %d", day18part2(lines));
  return 0;
}
