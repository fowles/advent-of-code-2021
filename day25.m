#import <Foundation/Foundation.h>

#import "day25.h"
#import "parsing.h"

typedef struct {
  int w, h;
  char s[140][140];
} SeaFloor;

void Draw(SeaFloor* f) {
  for (int j = 0; j < f->h; ++j) {
    for (int i = 0; i < f->w; ++i) {
      printf("%c", f->s[i][j]);
    }
    printf("\n");
  }
}

bool Advance(SeaFloor* c) {
  bool change = false;
  for (int j = 0; j < c->h; ++j) {
    for (int i = 0; i < c->w; ++i) {
      int di = (i + 1) % c->w;
      if (c->s[i][j] == '>' && c->s[di][j] == '.') {
        c->s[i][j] = '>' - 1;
        c->s[di][j] = '>' + 1;
        change = true;
      }
    }
  }
  for (int j = 0; j < c->h; ++j) {
    for (int i = 0; i < c->w; ++i) {
      int dj = (j + 1) % c->h;
      if (c->s[i][j] == 'v' && (c->s[i][dj] == '.' || c->s[i][dj] == '>' - 1)) {
        c->s[i][j] = 'v' - 1;
        c->s[i][dj] = 'v' + 1;
        change = true;
      }
    }
  }
  if (change) {
    for (int j = 0; j < c->h; ++j) {
      for (int i = 0; i < c->w; ++i) {
        char r = c->s[i][j];
        switch (r) {
        case 'v' - 1: r = '.'; break;
        case 'v' + 1: r = 'v'; break;
        case '>' - 1: r = '.'; break;
        case '>' + 1: r = '>'; break;
        }
        c->s[i][j] = r;
      }
    }
  }
  return change;

}

int day25part1(SeaFloor* f) {
  int step = 1;
  while (Advance(f)) {
    ++step;
  }
  return step;
}

int day25part2(SeaFloor* f) {
  return 0;
}

int day25main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day25.txt"));
  SeaFloor f;
  f.h = (int)[lines count];
  for (int j = 0; j < f.h; ++j) {
    id line = lines[j];
    f.w = (int)[line length];
    for (int i = 0; i < f.w; ++i) {
      f.s[i][j] = [line characterAtIndex:i];
    }
  }
  NSLog(@"Part 1: %d", day25part1(&f));
  NSLog(@"Part 2: %d", day25part2(&f));
  return 0;
}
