#import <Foundation/Foundation.h>

#import "day12.h"
#import "parsing.h"

typedef NSMutableDictionary<NSString*, NSMutableArray*> Graph;

bool IsBig(NSString* s) {
  char c = [s characterAtIndex: 0];
  return 'A' <= c && c <= 'Z';
}

@interface Path:NSObject {
  NSMutableArray* path;
  NSMutableSet<NSString*>* seen;
  bool duplicate_used;
}

+ (instancetype)init:(bool)duplicate_used;
- (instancetype)copy;
- (NSString*)description;
- (NSString*)curPos;
- (bool)isAtEnd;
- (Path*)extendPath:(NSString*)node;
@end

@implementation Path
+ (instancetype)init:(bool)duplicate_used {
  Path* p = [Path alloc];
  p->path = [NSMutableArray arrayWithCapacity:8];
  p->seen = [NSMutableSet setWithCapacity: 8];
  p->duplicate_used = duplicate_used;
  [p visit:@"start"];
  return p;
}

- (instancetype)copy {
  Path* p = [Path alloc];
  p->path = [self->path mutableCopy];
  p->seen = [self->seen mutableCopy];
  p->duplicate_used = self->duplicate_used;
  return p;
}

- (NSString*)description {
  return [NSString stringWithFormat:@"%@", self->path];
}

- (NSString*)curPos {
  return self->path[self->path.count - 1];
}

- (bool)isAtEnd {
  return [[self curPos] isEqualToString: @"end"];
}

- (void)visit:(NSString*) node {
  [self->path addObject: node];
  if (!IsBig(node)) [self->seen addObject: node];
}

- (Path*)extendPath:(NSString*)node {
  if (IsBig(node)) {
    Path* p = [self copy];
    [p->path addObject:node];
    return p;
  }

  if ([self->seen containsObject:node]) {
    if (self->duplicate_used) return nil;
    if ([node isEqualToString: @"start"]) return nil;
    Path* p = [self copy];
    [p->path addObject:node];
    p->duplicate_used = true;
    return p;
  }

  Path* p = [self copy];
  [p->path addObject:node];
  [p->seen addObject:node];
  return p;
}
@end

NSMutableArray<Path*>* ExpandPath(Graph* graph, Path* path) {
  id res = [NSMutableArray arrayWithCapacity: 4];
  for (id n in graph[[path curPos]]) {
    id p = [path extendPath: n];
    if (p != nil) {
      [res addObject: p];
    }
  }
  return res;
}

size_t countExpansion(Graph* graph, bool duplicate_used) {
  id paths = [NSMutableArray arrayWithCapacity:500];
  id to_expand = [NSMutableArray arrayWithCapacity:500];
  [to_expand addObject:[Path init:duplicate_used]];
  while ([to_expand count] > 0) {
    id ex = to_expand[[to_expand count] - 1];
    [to_expand removeLastObject];
    for (id path in ExpandPath(graph, ex)) {
      if ([path isAtEnd]) {
        [paths addObject: path];
      } else {
        [to_expand addObject: path];
      }
    }
  }
  return [paths count];
}

size_t day12part1(Graph* graph) {
  return countExpansion(graph, true);
}

size_t day12part2(Graph* graph) {
  return countExpansion(graph, false);
}

int day12main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day12.txt"));
  NSArray<NSArray<NSString*>*>* edges = parseLines(
      lines, [NSRegularExpression regularExpressionWithPattern:@"(\\w+)"
                                                       options:0
                                                         error:NULL]);
  Graph* graph = [NSMutableDictionary dictionaryWithCapacity:edges.count];
  for (id edge in edges) {
    id node = graph[edge[0]];
    if (node == nil) {
      graph[edge[0]] = node = [NSMutableArray arrayWithCapacity: 8];
    }
    [node addObject: edge[1]];

    node = graph[edge[1]];
    if (node == nil) {
      graph[edge[1]] = node = [NSMutableArray arrayWithCapacity: 8];
    }
    [node addObject: edge[0]];
  }

  NSLog(@"Part 1: %zu", day12part1(graph));
  NSLog(@"Part 2: %zu", day12part2(graph));
  return 0;
}
