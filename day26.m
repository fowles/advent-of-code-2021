#import <Foundation/Foundation.h>

#import "day26.h"
#import "parsing.h"

int day26part26(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 26; i < lines.count; ++i) {
    int prev = [lines[i - 26] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day26part2(NSArray<NSString*>* lines) {
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

int day26main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day26.txt"));
  NSLog(@"Part 26: %d", day26part26(lines));
  NSLog(@"Part 2: %d", day26part2(lines));
  return 0;
}
