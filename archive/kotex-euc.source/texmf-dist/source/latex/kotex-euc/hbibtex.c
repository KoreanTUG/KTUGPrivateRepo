#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define HEXA_STRING "0123456789abcdef"

#ifdef WIN32
#include <io.h>
#include <ctype.h>
#define MKSTEMP mktemp
#else
#define MKSTEMP mkstemp
#endif

int to_8bit(char *);

main(int argc, char *argv[])
{
  int i;
  char args[128], cmd[128];

#ifdef WIN32
  strcpy(args, "");
#else
  bzero(args, 128);
#endif

  for(i=1; i<argc; i++) {
    strcat(args, " ");
    strcat(args, argv[i]);
  }

  to_8bit(argv[argc-1]);
  sprintf(cmd, "bibtex %s", args);
  system(cmd);

  exit(0);
}

int to_8bit(char *bib) {
  FILE *in, *out;
  int x;
  char line[1024], *l, *h1, *h2, tempfile[10];

  l=strrchr(bib, '.');
  if(l==NULL || strcmp(l, ".aux")!=0) {
    strcat(bib, ".aux");
  }

  in = fopen(bib, "r");
  if(!in) {
    printf("\tError opening auxiliary file \"%s\"!!!\n", bib);
    exit(1);
  }

  strcpy(tempfile, "BIBXXXXXX");
  MKSTEMP(tempfile);
  out = fopen(tempfile, "w");
  if(!out) {
    printf("\tError opening temporary file \"%s\"!!!\n", tempfile);
    exit(1);
  }

  while(fgets(line, 1024, in)) {
    l=line;
    while(*l) {
      if(*l=='^'&&*(l+1)=='^'
	 &&(h1=strchr(HEXA_STRING, *(l+2)))
	 &&(h2=strchr(HEXA_STRING, *(l+3)))) {
	if(*h1>'9') x=*h1-87;
	else x=*h1-48;
	x*=16;
	if(*h2>'9') x+=*h2-87;
	else x+=*h2-48;
	fputc(x, out);
	l+=4;
      }
      else {
	fputc(*l++, out);
      }
    }
  }
  fflush(NULL);
  fclose(in);
  fclose(out);

  rename(tempfile, bib);

  return(1);
}
