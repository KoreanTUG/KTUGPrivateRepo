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

#define BIT(x) (1<<x)

char idx[1024], ind[1024];
int cho=-1, style_used=0;
int to_8bit(void);
int hangul_head(int);
int doublebyte(int, int);
int triplebyte(unsigned int, unsigned int, unsigned int);
int ucs(int);
void fputs_item(char *, FILE *);

main(int argc, char *argv[])
{
  int i, outfile_used=0;
  char prog[1024], args[1024], cmd[128], idx0[1024];
  char *t, *l;

  strcpy(prog, argv[0]);
#ifdef WIN32
  strcpy(args, "");
  strcpy(ind, "");
#else
  bzero(args, 1024);
  bzero(ind, 1024);
#endif

  printf("This is hmakeindex, version 1.0 (makeindex wrapper for Korean support).\n");

  for(i=1; i<argc; i++) {
    strcat(args, " ");
    t=argv[i];
    strcat(args, t);
    switch(*t) {
    case '-':
      t++;
      switch(*t) {
      case 'o':
	outfile_used=1;
	strcat(args, " ");
	strcat(args, argv[++i]);
	strcpy(ind, argv[i]);
	if((l=strrchr(ind, '.'))&&*(l+1)=='i'&&*(l+2)=='n'&&*(l+3)=='d')
	  *l=0;
	break;
      case 'p':
	strcat(args, " ");
	strcat(args, argv[++i]);
	break;
      case 's':
	strcat(args, " ");
	strcat(args, argv[++i]);
	style_used=1;
	break;
      case 't':
	strcat(args, " ");
	strcat(args, argv[++i]);
	break;
      default:
	break;
      }
      break;
    default:
      if((l=strrchr(argv[i], '.'))&&*(l+1)=='i'&&*(l+2)=='d'&&*(l+3)=='x')
	*l=0;
      strcpy(idx, argv[i]);
      strcpy(idx0, argv[i]);
      strcat(idx, ".idx");
      break;
    }
  }

  i=to_8bit();
  sprintf(cmd, "makeindex %s", args);
  system(cmd);

  if(outfile_used==0) {
    strcpy(ind, idx0);
    strcat(ind, ".ind");
  }
  hangul_head(i);

  exit(0);
}

int to_8bit() {
  FILE *in, *out;
  char line[1024], *h1, *h2, tempfile[9];
  unsigned char *l;
  int x, w=0, utf_seen=0, hangul_enc=0;

  in = fopen(idx, "r");
  if(!in) {
    printf("\tError opening index file \"%s\"!!!\n", idx);
    exit(1);
  }

  strcpy(tempfile, "IDXXXXXXX");
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
	hangul_enc=1;
	if(w<161 || x<161) utf_seen=1;
	w=x;
      }
      else {
	if(w>127 && *l>127) {
	  /* 이미 변환된 .idx 파일의 경우 */
	  hangul_enc=1;
	  if(w<161 || *l<161) utf_seen=1;
	}
	w=*l;
	/* 위치 표시 문자 '@'는 '\a'으로 변환하여 makeindex로 처리한 후
	   나중에 제거한다. \hindexhead{#}의 "#" 처리에서 오류가 발생 */
	if(*(l-1)!='"' && *l=='@') fputc('\a', out);
	else fputc(*l, out);
	l++;
      }
    }
  }
  fflush(NULL);
  fclose(in);
  fclose(out);

  rename(tempfile, idx);

  return(hangul_enc+utf_seen);
}

int hangul_head(encoding) {
  FILE *in, *out;
  char tempfile[9];
  unsigned char line[1024], *l;
  unsigned int cho=20, x;

  strcpy(tempfile, "INDXXXXXX");
  MKSTEMP(tempfile);
  in=fopen(ind, "r");
  out=fopen(tempfile, "w");

  while(fgets(line, 1024, in)) {
    l=line;
    while(isspace(*l)) l++;
    if(strncmp(l, "\\item", 5)==0) {
      l+=5;
      while(isspace(*l)) l++;
      if(*l<128) {
	fputs_item(line, out);
	continue;
      }
      switch(encoding) {
      case 1: /* EUC-KR */
	x=doublebyte(*l, *(l+1));
	break;
      case 2: /* UTF-8 */
	x=triplebyte(*l, *(l+1), *(l+2));
	break;
      default:
	fprintf(stderr, "Encoding error in the ind file\n");
	fputs(line, out);
	break;
      }
      if(x!=cho && x<20) {
	cho=x;
	fprintf(out, "\n\\hindexhead{%d}\n", cho);
      }
      fputs_item(line, out);
    }
    else if(strncmp(l, "\\indexspace", 11)==0) {
      if(cho<0 || cho>19) fputs(line, out);
    }
    else if(!(strncmp(l, "\\indexhead{", 11)==0&&*(l+11)>128)) {
      fputs(line, out);
    }
  }

  fflush(NULL);
  fclose(in);
  fclose(out);

  rename(tempfile, ind);

  return(1);
}

void fputs_item(char *item, FILE *fp) {
  char *s;

  if((s=strchr(item, '\a'))) fprintf(fp, "  \\item %s", ++s);
  else fputs(item, fp);
}

int doublebyte(int first, int second) {
  unsigned int ksc;

  if(first<0xa1) return(21);
  else if(first<0xb1) return(0);
  else if(first>0xc8) return(20);
  ksc=(first<<8)+second;
  if(ksc<0xb1ee) return(1);
  else if(ksc<0xb3aa) return(2);
  else if(ksc<0xb4d9) return(3);
  else if(ksc<0xb5fb) return(4);
  else if(ksc<0xb6f3) return(5);
  else if(ksc<0xb8b6) return(6);
  else if(ksc<0xb9d9) return(7);
  else if(ksc<0xbafc) return(8);
  else if(ksc<0xbbe7) return(9);
  else if(ksc<0xbdce) return(10);
  else if(ksc<0xbec6) return(11);
  else if(ksc<0xc0da) return(12);
  else if(ksc<0xc2a5) return(13);
  else if(ksc<0xc2f7) return(14);
  else if(ksc<0xc4ab) return(15);
  else if(ksc<0xc5b8) return(16);
  else if(ksc<0xc6c4) return(17);
  else if(ksc<0xc7cf) return(18);
  else if(ksc<0xc8ff) return(19);
  else return(-1);
}

int triplebyte(unsigned int first, unsigned int second, unsigned int third) {
  unsigned int utf;
  int i;

  if(first<=0x7f) utf=first;
  else {
    i=0;
    while(first & BIT((6-i))) i++;
    switch(i) {
    case 1:
      utf=((first - BIT(7) - BIT(6))<<6);
      utf+=(second - BIT(7));
      break;
    case 2:
      utf=((first - BIT(7) - BIT(6) - BIT(5))<<12);
      utf+=((second - BIT(7))<<6);
      utf+=(third - BIT(7));
      break;
    default:
      break;
    }
  }

  if(0xac00<=utf && utf<=0xd7a3)
    return((utf-0xac00)/(21*28)+1);
  else if((0x4e00<=utf && utf>=0x9fff) ||
	  (0xf900<=utf && utf>=0xfaff)) return(20);
  else if(utf==first) return(21);
  else return(0);
}
