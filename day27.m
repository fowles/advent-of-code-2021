#import <Foundation/Foundation.h>

#import "day27.h"
#import "parsing.h"

int day27part27(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 27; i < lines.count; ++i) {
    int prev = [lines[i - 27] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day27part2(NSArray<NSString*>* lines) {
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

int day27main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day27.txt"));
  NSLog(@"Part 27: %d", day27part27(lines));
  NSLog(@"Part 2: %d", day27part2(lines));
  return 0;
}
