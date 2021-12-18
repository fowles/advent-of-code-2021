#import <Foundation/Foundation.h>

#import "day10.h"
#import "parsing.h"

size_t ScoreCorrupt(char c) {
  switch (c) {
    case ')': return 3;
    case ']': return 57;
    case '}': return 1197;
    case '>': return 25137;
    default:  return 0;
  }
}

size_t ScoreComplete(NSString* s) {
  size_t res = 0;
  for (size_t p = s.length; p > 0; --p) {
    char c = [s characterAtIndex:p-1];
    res *= 5;
    switch (c) {
    case '(': res += 1; break;
    case '[': res += 2; break;
    case '{': res += 3; break;
    case '<': res += 4; break;
    }
  }
  return res;
}

char balance(char c) {
  switch (c) {
  case '(': return ')';
  case '[': return ']';
  case '{': return '}';
  case '<': return '>';
  case ')': return '(';
  case ']': return '[';
  case '}': return '{';
  case '>': return '<';
  default:  return 0;
  }
}

typedef struct {
  size_t pos;
  NSMutableString* stack;
} ScanResult;

ScanResult scan(NSString* s) {
  ScanResult res = {};
  res.stack = [NSMutableString stringWithCapacity:s.length];
  for (res.pos = 0; res.pos < s.length; ++res.pos) {
    char  c = [s characterAtIndex: res.pos];
    switch (c) {
    case '(':
    case '[':
    case '{':
    case '<':
      [res.stack appendFormat:@"%c", c];
      break;
    case ')':
    case ']':
    case '}':
    case '>':
      if (res.stack.length == 0) {
        [NSException raise:@"Parse error"
                    format:@"Unopened delimiter %c in %@", c, s];
      }

      size_t tail = res.stack.length - 1;
      char b = balance(c);
      if ([res.stack characterAtIndex:tail] == b) {
        [res.stack deleteCharactersInRange:NSMakeRange(tail, 1)];
      } else {
        return res;
      }
      break;
    }
  }
  return res;
}

size_t day10part1(NSArray<NSString*>* lines) {
  size_t res = 0;
  for (NSString* l in lines) {
    ScanResult r = scan(l);
    if (r.pos != l.length) {
      res += ScoreCorrupt([l characterAtIndex:r.pos]);
    }
  }
  return res;
}

size_t day10part2(NSArray<NSString*>* lines) {
  id scores = [NSMutableArray arrayWithCapacity:lines.count];
  for (NSString* l in lines) {
    ScanResult r = scan(l);
    if (r.pos == l.length) {
      [scores addObject: @(ScoreComplete(r.stack))];
    }
  }
  scores = [scores sortedArrayUsingSelector:@selector(compare:)];
  return [scores[[scores count] / 2] unsignedLongLongValue];
}

int day10main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day10.txt"));
  NSLog(@"Part 1: %zu", day10part1(lines));
  NSLog(@"Part 2: %zu", day10part2(lines));
  return 0;
}
