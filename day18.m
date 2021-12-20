#import <Foundation/Foundation.h>

#import "day18.h"
#import "parsing.h"

@interface SFNumber:NSObject {
  int lval;
  int rval;
  SFNumber* lnum;
  SFNumber* rnum;
  __weak SFNumber* parent;
}

+ (instancetype)init:(SFNumber*)parent;
+ (instancetype)parse:(NSString*)s;
+ (instancetype)split:(int)v with:(SFNumber*)parent;
- (NSString*)description;
- (SFNumber*)add:(SFNumber*)other;
- (SFNumber*)regularize;
- (int)magnitude;
- (bool)maybeExplode:(int)depth;
- (bool)maybeSplit;
- (void)pushValue:(int)v leftFrom:(SFNumber*)n;
- (void)pushValue:(int)v rightFrom:(SFNumber*)n;
- (void)addLeftMost:(int)v;
- (void)addRightMost:(int)v;
@end

@implementation SFNumber
+ (instancetype)init: parent {
  SFNumber* s = [SFNumber alloc];
  s->lval = 0;
  s->rval = 0;
  s->lnum = nil;
  s->rnum = nil;
  s->parent = parent;
  return s;
}

+ (instancetype)parse:(NSString*)t {
  int pos = 0;
  return [SFNumber parse:t at:&pos with:nil];
}

+ (instancetype)parse:(NSString*)t at:(int*)pos with:(SFNumber*)parent{
  SFNumber* s = [SFNumber init: parent];
  char c = [t characterAtIndex: *pos];
  assert(c == '[');
  ++*pos;

  c = [t characterAtIndex: *pos];
  if (c == '[')  {
    s->lnum = [SFNumber parse:t at:pos with:s];
  } else {
    ++*pos;
    s->lval = c - '0';
  }

  c = [t characterAtIndex: *pos];
  assert(c == ',');
  ++*pos;

  c = [t characterAtIndex: *pos];
  if (c == '[')  {
    s->rnum = [SFNumber parse:t at:pos with:s];
  } else {
    ++*pos;
    s->rval = c - '0';
  }

  c = [t characterAtIndex: *pos];
  assert(c == ']');
  ++*pos;
  return s;
}

+ (instancetype)split:(int)v with:(SFNumber*)parent {
  SFNumber* s = [SFNumber init:parent];
  s->lval = v/2;
  s->rval = v/2 + v%2;
  return s;
}

- (NSString*)description {
  id lhs, rhs;
  if (lnum == nil) {
    lhs = [NSString stringWithFormat:@"%d", lval];
  } else {
    lhs = [lnum description];
  }
  if (rnum == nil) {
    rhs = [NSString stringWithFormat:@"%d", rval];
  } else {
    rhs = [rnum description];
  }

  return [NSString stringWithFormat:@"[%@,%@]", lhs, rhs];
}

- (SFNumber*)add:(SFNumber*)other {
  SFNumber* r = [SFNumber init:nil];
  r->lnum = self;
  r->rnum = other;
  self->parent = r;
  other->parent = r;
  return r;
}

- (SFNumber*)regularize {
  while (true) {
    if ([self maybeExplode:0]) {
      continue;
    }
    if ([self maybeSplit]) {
      continue;
    }
    return self;
  }
}

- (int)magnitude {
  int res = 0;
  if (self->lnum == nil) {
    res += 3*self->lval;
  } else {
    res += 3*[self->lnum magnitude];
  }
  if (self->rnum == nil) {
    res += 2*self->rval;
  } else {
    res += 2*[self->rnum magnitude];
  }
  return res;
}

- (bool)maybeExplode:(int)depth {
  if (depth > 3) {
    if (self->lnum == nil && self->rnum == nil) {
      SFNumber* p = self->parent;
      [p pushValue:self->rval rightFrom:self];
      [p pushValue:self->lval leftFrom:self];
      if (p->lnum == self) {
        p->lnum = nil;
        p->lval = 0;
      }
      if (p->rnum == self) {
        p->rnum = nil;
        p->rval = 0;
      }
      return true;
    }
  }

  if (self->lnum != nil) {
    if ([self->lnum maybeExplode:depth + 1]) return true;
  }
  if (self->rnum != nil) {
    if ([self->rnum maybeExplode:depth + 1]) return true;
  }
  return false;
}

- (bool)maybeSplit {
  if (self->lnum != nil) {
    if ([self->lnum maybeSplit]) {
      return true;
    }
  } else if (self->lval > 9) {
    self->lnum = [SFNumber split:self->lval with:self];
    self->lval = 0;
    return true;
  }

  if (self->rnum != nil) {
    if ([self->rnum maybeSplit]) {
      return true;
    }
  } else if (self->rval > 9) {
    self->rnum = [SFNumber split:self->rval with:self];
    self->rval = 0;
    return true;
  }

  return false;
}

- (void)pushValue:(int)v leftFrom:(SFNumber*)n {
  if (n == self->lnum) {
    if (self->parent != nil) {
      [self->parent pushValue:v leftFrom:self];
    }
    return;
  }

  if (n == self->rnum) {
    if (self->lnum == nil) {
      self->lval += v;
    } else {
      [self->lnum addRightMost: v];
    }
    return;
  }

  [NSException raise:@"Logic error"
              format:@"Bug in pushValue leftFrom"];
}

- (void)pushValue:(int)v rightFrom:(SFNumber*)n {
  if (n == self->rnum) {
    if (self->parent != nil) {
      [self->parent pushValue:v rightFrom:self];
    }
    return;
  }

  if (n == self->lnum) {
    if (self->rnum == nil) {
      self->rval += v;
    } else {
      [self->rnum addLeftMost: v];
    }
    return;
  }

  [NSException raise:@"Logic error"
              format:@"Bug in pushValue rightFrom"];
}

- (void)addLeftMost:(int)v {
  if (self->lnum == nil) {
    self->lval += v;
  } else {
    [self->lnum addLeftMost:v];
  }
}

- (void)addRightMost:(int)v {
  if (self->rnum == nil) {
    self->rval += v;
  } else {
    [self->rnum addRightMost:v];
  }
}
@end

int day18part1(NSArray<SFNumber*>* lines) {
  SFNumber* res = lines[0];
  for (int i = 1; i < lines.count; ++i) {
    res = [res add: lines[i]];
    [res regularize];
  }
  return [res magnitude];
}

int day18part2(NSArray<SFNumber*>* lines) {
  return 0;
}

void Test(SFNumber* lhs, SFNumber* rhs) {
  id l = [lhs description];
  id r = [rhs description];
  if (![l isEqualToString:r]) {
    [NSException raise:@"Failure" format:@"%@ == %@", l, r];
  }
}

int day18main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day18.txt"));
  id nums = [NSMutableArray arrayWithCapacity:[lines count]];
  for (id l in lines) {
    [nums addObject:[SFNumber parse: l]];
  }
  Test([[SFNumber parse:@"[[[[[9,8],1],2],3],4]"] regularize],
       [SFNumber parse:@"[[[[0,9],2],3],4]"]);
  Test([[SFNumber parse:@"[7,[6,[5,[4,[3,2]]]]]"] regularize],
       [SFNumber parse:@"[7,[6,[5,[7,0]]]]"]);

  NSLog(@"Part 1: %d", day18part1(nums));
  NSLog(@"Part 2: %d", day18part2(nums));
  return 0;
}
