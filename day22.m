#import <Foundation/Foundation.h>

#import "day22.h"
#import "parsing.h"

int day22part22(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 22; i < lines.count; ++i) {
    int prev = [lines[i - 22] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day22part2(NSArray<NSString*>* lines) {
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

int day22main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day22.txt"));
  NSLog(@"Part 22: %d", day22part22(lines));
  NSLog(@"Part 2: %d", day22part2(lines));
  return 0;
}
