#import <Foundation/Foundation.h>

#import "day19.h"
#import "parsing.h"
#import "Matrix.h"

@interface Pair:NSObject 
@property(nonatomic, readwrite) int i;
@property(nonatomic, readwrite) int j;
@end

@implementation Pair
- (NSString*)description {
  return [NSString stringWithFormat:@"%d,%d", self.i, self.j];
}
@end

@interface Position : NSObject <NSCopying>
@property(nonatomic, readwrite) int x;
@property(nonatomic, readwrite) int y;
@property(nonatomic, readwrite) int z;

+ (instancetype)parse:(NSString*)line;
+ (instancetype)x:(int)x y:(int)y z:(int)z;
- (Position*)copy;
- (Position*)copyWithZone:(NSZone*)zone;
- (Position*)add:(Position*)rhs;
- (Position*)sub:(Position*)rhs;
- (NSArray<Position*>*)rotations;
@end

@implementation Position
+ (instancetype)parse:(NSString*)line {
  id parsed = parseLine(
      line, [NSRegularExpression
                regularExpressionWithPattern:@"(-?\\d+),(-?\\d+),(-?\\d+)"
                                     options:0
                                       error:NULL]);
  return [Position x:[parsed[0] intValue]
                   y:[parsed[1] intValue]
                   z:[parsed[2] intValue]];
}

+ (instancetype)x:(int)x y:(int)y z:(int)z {
  Position* p = [Position alloc];
  p.x = x;
  p.y = y;
  p.z = z;
  return p;
}

- (Position*)copy {
  return [Position x:self.x y:self.y z:self.z];
}

- (Position*)copyWithZone:(NSZone*)zone {
  return [self copy];
}

- (Position*)add:(Position*)lhs {
  return [Position x:self.x + lhs.x y:self.y + lhs.y z:self.z + lhs.z];
}

- (Position*)sub:(Position*)lhs {
  return [Position x:self.x - lhs.x y:self.y - lhs.y z:self.z - lhs.z];
}

- (BOOL)isEqual:(id)object {
  if ([object isKindOfClass:[self class]]) {
    Position* o = object;
    return self.x == o.x && self.y == o.y && self.z == o.z;
  }

  return NO;
}

- (NSUInteger)hash {
  NSUInteger result = 1;
  NSUInteger prime = 31;
  result = prime * result + self.x;
  result = prime * result + self.y;
  result = prime * result + self.z;
  return result;
}

- (NSArray<Position*>*)rotations {
  NSMutableArray<Position*>* r = [NSMutableArray arrayWithCapacity:24];
  Position* s = self;
  [r addObject:[Position  x: s.x  y: s.y  z: s.z]];
  [r addObject:[Position  x:-s.z  y: s.y  z: s.x]];
  [r addObject:[Position  x:-s.x  y: s.y  z:-s.z]];
  [r addObject:[Position  x: s.z  y: s.y  z:-s.x]];
  [r addObject:[Position  x: s.y  y:-s.x  z: s.z]];
  [r addObject:[Position  x: s.y  y: s.z  z: s.x]];
  [r addObject:[Position  x: s.y  y: s.x  z:-s.z]];
  [r addObject:[Position  x: s.y  y:-s.z  z:-s.x]];
  [r addObject:[Position  x:-s.y  y: s.x  z: s.z]];
  [r addObject:[Position  x:-s.y  y:-s.z  z: s.x]];
  [r addObject:[Position  x:-s.y  y:-s.x  z:-s.z]];
  [r addObject:[Position  x:-s.y  y: s.z  z:-s.x]];
  [r addObject:[Position  x: s.x  y: s.z  z:-s.y]];
  [r addObject:[Position  x:-s.z  y: s.x  z:-s.y]];
  [r addObject:[Position  x:-s.x  y:-s.z  z:-s.y]];
  [r addObject:[Position  x: s.z  y:-s.x  z:-s.y]];
  [r addObject:[Position  x: s.x  y:-s.y  z: s.z]];
  [r addObject:[Position  x:-s.z  y:-s.y  z:-s.x]];
  [r addObject:[Position  x:-s.x  y:-s.y  z: s.z]];
  [r addObject:[Position  x: s.z  y:-s.y  z: s.x]];
  [r addObject:[Position  x: s.x  y:-s.z  z: s.y]];
  [r addObject:[Position  x:-s.z  y:-s.x  z: s.y]];
  [r addObject:[Position  x:-s.x  y: s.z  z: s.y]];
  [r addObject:[Position  x: s.z  y: s.x  z: s.y]];
  assert(r.count == 24);
  return r;
}

- (NSString*)description {
  return [NSString stringWithFormat:@"%d,%d,%d", self.x, self.y, self.z];
}
@end

NSMutableDictionary<NSNumber*, NSMutableArray<Pair*>*>* ClusterNorms(Matrix* m) {
  id r = [NSMutableDictionary dictionaryWithCapacity:m.rows * m.columns];
  for (int i = 0; i < m.rows; ++i) {
    for (int j = i + 1; j < m.columns; ++j) {
      id k = @([m i:i j:j]);
      id v = r[k];
      if (v == nil) {
        v = [NSMutableArray arrayWithCapacity:1];
      }
      Pair* p = [Pair alloc];
      p.i = i;
      p.j = j;
      [v addObject: p];
      r[k] = v;
    }
  }
  return r;
}

Matrix* ComputeNorms(NSArray<Position*>* beacons) {
  int dim = (int)beacons.count;
  Matrix* m = [Matrix matrixOfRows:dim columns:dim];
  for (int i = 0; i < dim; ++i) {
    for (int j = i; j < dim; ++j) {
      Position* p = [beacons[i] sub: beacons[j]];
      double l2 = 0;
      l2 += p.x*p.x;
      l2 += p.y*p.y;
      l2 += p.z*p.z;
      [m i:i j:j set:l2];
      [m i:j j:i set:l2];
    }
  }
  return m;
}

NSMutableArray<Position*>* ParseBeacons(NSString* text) {
  id lines = splitLines(text);
  size_t num_lines = [lines count];
  id beacons = [NSMutableArray arrayWithCapacity:num_lines - 1];
  for (size_t i = 1; i < num_lines; ++i) {
    [beacons addObject:[Position parse:lines[i]]];
  }
  return beacons;
}

@interface Scanner:NSObject {
  @public NSMutableArray<Position*>* beacons;
  Matrix* norms;
  NSMutableDictionary<NSNumber*, NSMutableArray<Pair*>*>* clustered_norms;
}
@property(nonatomic, readwrite) Position* position;

+ (instancetype)parse:(NSString*)text;
- (NSString*)description;
- (Matrix*)l2Matrix;
- (int)sharedL2Norms:(Scanner*)other;
- (void)fixPosition:(Scanner*)other;
@end

@implementation Scanner
+ (instancetype)parse:(NSString*)text; {
  Scanner* s = [Scanner alloc];
  s->beacons = ParseBeacons(text);
  s->norms = ComputeNorms(s->beacons);
  s->clustered_norms = ClusterNorms(s->norms);
  return s;
}

- (NSString*)description {
  return [NSString stringWithFormat:@"Scanner\n%@", beacons];
}

- (Matrix*)l2Matrix {
  return norms;
}

- (int)sharedL2Norms:(Scanner*)other {
  id lhs = self->clustered_norms;
  id rhs = other->clustered_norms;

  int overlap = 0;
  for (id k in lhs) {
    id r = rhs[k];
    if (r != nil) {
      id l = lhs[k];
      overlap += (int)MIN([r count], [l count]);
    }
  }
  return overlap;
}

- (void)fixPosition:(Scanner*)right {
  Scanner* left = self;
  assert([left sharedL2Norms: right] >= 66);
  assert(right.position != nil);

  id lhs = left->clustered_norms;
  id rhs = right->clustered_norms;

  Matrix* m = [Matrix matrixOfRows:(int)[left->beacons count]
                           columns:(int)[right->beacons count]];
  for (id k in lhs) {
    id r = rhs[k];
    if (r != nil) {
      id l = lhs[k];

      if ([l count] + [r count] > 2) {
        continue;
      }
      l = l[0];
      r = r[0];
      [m i:[l i] j:[r i] increment:1];
      [m i:[l i] j:[r j] increment:1];
      [m i:[l j] j:[r i] increment:1];
      [m i:[l j] j:[r j] increment:1];
    }
  }

  NSMutableDictionary<Position*, NSNumber*>* candidates =
      [NSMutableDictionary dictionaryWithCapacity:512];
  int best = 0;
  Position* best_pos = nil;
  int best_rotation = 0;

  double max = m.max;
  Position* p = right.position;
  for (int i = 0; i < m.rows; ++i) {
    for (int j = 0; j < m.columns; ++j) {
      if ([m i:i j:j] == max) {
        Position* r = right->beacons[j];

        NSArray<Position*>* rotations = [left->beacons[i] rotations];
        for (int k = 0; k < rotations.count; ++k) {
          Position* l = rotations[k];
          Position* a = [[p add: r] sub: l];
          int votes = [candidates[a] intValue] + 1;
          candidates[a] = @(votes);
          if (votes > best) {
            best = votes;
            best_pos = a;
            best_rotation = k;
          }
        }
      }
    }
  }

  self.position = best_pos;
  for (Position* p in self->beacons) {
    Position* r = [p rotations][best_rotation];
    p.x = r.x;
    p.y = r.y;
    p.z = r.z;
  }
  assert(self.position != nil);
}
@end

int day19part1(NSArray<Scanner*>* scanners) {
  int size = (int)[scanners count];
  Matrix* m = [Matrix matrixOfRows:size columns:size];
  for (int i = 0; i < size; ++i) {
    for (int j = i + 1; j < size; ++j) {
      int overlap = [scanners[i] sharedL2Norms:scanners[j]];
      [m i:i j:j set:overlap];
      [m i:j j:i set:overlap];
    }
  }
RETRY:
  for (int i = 0; i < size; ++i) {
    for (int j = 0; j < size; ++j) {
      if ([m i:i j:j] >= 66) {
        if (scanners[i].position != nil && scanners[j].position == nil) {
          [scanners[j] fixPosition:scanners[i]];
        }
      }
    }
  }

  for (Scanner* s in scanners) {
    if (s.position == nil) goto RETRY;
  }

  id all = [NSMutableSet setWithCapacity:512];
  for (Scanner* s in scanners) {
    for (id b in s->beacons) {
      [all addObject: [s.position add: b]];
    }
  }
  return (int)[all count];
}

int day19part2() {
  return 0;
}

int day19main(int argc, const char** argv) {
  id scanner_texts = split(readFile(@"input/day19.txt"), @"\n\n");
  NSMutableArray<Scanner*>* scanners = [NSMutableArray arrayWithCapacity:38];
  for (id text in scanner_texts ) {
    [scanners addObject:[Scanner parse:text]];
  }
  [scanners[0] setPosition: [Position alloc]];

  NSLog(@"Part 1: %d", day19part1(scanners));
  NSLog(@"Part 2: %d", day19part2());
  return 0;
}
