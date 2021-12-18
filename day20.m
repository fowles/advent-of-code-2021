#import <Foundation/Foundation.h>

#import "day20.h"
#import "parsing.h"

int day20part20(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 20; i < lines.count; ++i) {
    int prev = [lines[i - 20] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day20part2(NSArray<NSString*>* lines) {
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

int day20main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day20.txt"));
  NSLog(@"Part 20: %d", day20part20(lines));
  NSLog(@"Part 2: %d", day20part2(lines));
  return 0;
}
