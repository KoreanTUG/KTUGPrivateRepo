# KTUG Private Repository

**To browse the repository more conviniently, use [KTUG PR browser](https://koreantug.github.io/ktugpr-browser).**

한국어 가이드는 : http://wiki.ktug.org/wiki/wiki.php/KtugPrivateRepository

## Aim

- KTUG private repository aims to provide useful Korean-related TeX packages that aren't provided via TeXlive. Any users can manually install such packages through KTUG private repo.

## Usage

### Adding & Updating repo

- KTUG private repo. can be managed with tlmgr — TeXlive's utility.
- For Windows users - omit `sudo`; for linux - use `sudo -i`; for MacOS - just use followings.

1. Add KTUG private repo. 

   `$ sudo tlmgr repository add http://ftp.ktug.org/KTUG/texlive/tlnet ktug`

2. Add pinning. 

   `$ sudo tlmgr pinning add ktug "*"`

3. Install the package(s). 

   `$ sudo tlmgr install <package name 1> <package name 2> ...`

4. Installed packages can be updated with : 

   `$ sudo tlmgr update --all --self`

### Viewing package info.

`tlmgr info <package name>`

- This can be done even before installing the package(s).

### Removing package/repo

1. To remove the package(s), 

   `$ sudo tlmgr remove <package name 1> <package name 2> ...`

2. To remove the repo., 

   ```
   $ sudo tlmgr repository remove ktug
   $ sudo rm -f /usr/local/texlive/texmf-local/tlpkg/pinning.txt
   ```

### Managing pinning

1. To validate pinning,

   `$ tlmgr pinning show`

2. To remove pinning,

   ```
   $ sudo tlmgr pinning remove ktug --all
   $ sudo tlmgr pinning remove kotex --all (If `kotex:*` remains)
   ```

3. To add pinning,

   `$ sudo tlmgr pinning add ktug "*"`

## List of Packages

(In alphabetical order, as of 2018.01)

- **arara-rules-ko** 한글 사용자를 위한 arara rules 추가 
- **graphicsonthefly** web상의 그림을 includegraphics 
- **hangulfontset** 한글 폰트 설정 (xetex)
- **hanjacnt** 숫자를 한자로 변환
- **hcr-lvt** 함초롬LVT 트루타입 폰트
- **hnja2hngl** 한자로 입력된 텍스트에 한글 음을 (반)자동으로 붙여줌 (readhanja참조) 
- **ifpxltex** 엔진 확장
- **jiwonlipsum** lipsum for Korean 
- **ko-blacklist** luatex culprit font blacklist
- **kocircnum** 원숫자
- **kotex-euc** EUC-KR 한글 문서 작성
- **kotex-midkor** pdfTeX을 위한 옛한글 처리
- **kotex-sections** HLaTeX 식의 절 표제
- **ksbaduk** Drawing Baduk (go) Diagrams with TikZ
- **ksforloop** for-loop
- **ksmisc** misc packages by Karnes
- **ksruby** use ruby characters with xetexko
- **kswrapfig** 그림 주변으로 텍스트 흘리기
- **ktugbin** (Windows) 윈도우즈 사용자를 위한 ko.TeX Live 추가 실행 파일 
- **nanumbaruntype1** 나눔바른고딕 type1
- **nanumttf** 나눔명조/고딕 트루타입 
- **ob-chapstyles** oblivoir chapter styles 
- **readhanja** 한자 입력에 한글 음을 붙여줌. LuaLaTeX. 
- **texworks-config** (Windows) 윈도우즈 사용자를 위한 ko.TeX Live의 TeXworks 설정 
- **unfonts-base-type1** 은 글꼴 (type1)
- **unfonts-other-type1** 은 글꼴 (type1)
