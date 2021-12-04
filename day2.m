#import <Foundation/Foundation.h>

#import "day2.h"
#import "parsing.h"

int day2part1(NSArray<NSArray<NSString*>*>* commands) {
  int depth = 0;
  int position = 0;
  for (id command in commands) {
    if ([command[0] isEqualToString:@"forward"]) {
      position += [command[1] intValue];
    }
    if ([command[0] isEqualToString:@"down"]) {
      depth += [command[1] intValue];
    }
    if ([command[0] isEqualToString:@"up"]) {
      depth -= [command[1] intValue];
    }
  }
  return depth * position;
}

int day2part2(NSArray<NSArray<NSString*>*>* commands) {
  int depth = 0;
  int position = 0;
  int aim = 0;
  for (id command in commands) {
    if ([command[0] isEqualToString:@"forward"]) {
      position += [command[1] intValue];
      depth += aim * [command[1] intValue];
    }
    if ([command[0] isEqualToString:@"down"]) {
      aim += [command[1] intValue];
    }
    if ([command[0] isEqualToString:@"up"]) {
      aim -= [command[1] intValue];
    }
  }
  return depth * position;
}

int day2main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day2.txt"));
  id parsed = parseLines(
      lines, [NSRegularExpression regularExpressionWithPattern:@"(\\w+) (\\d+)"
                                                       options:0
                                                         error:NULL]);
  NSLog(@"Part 1: %d", day2part1(parsed));
  NSLog(@"Part 2: %d", day2part2(parsed));
  return 0;
}
