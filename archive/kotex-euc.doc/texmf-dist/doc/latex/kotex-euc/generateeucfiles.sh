#!/bin/bash
echo "euc mode" >definekg.eucmode
iconv -f UTF-8 -t EUC-KR KS.HAN.u.tex >KS.HAN.tex
iconv -f UTF-8 -t EUC-KR backmatters.tex >backmatters-k.tex
iconv -f UTF-8 -t EUC-KR biblio.tex >biblio-k.tex
iconv -f UTF-8 -t EUC-KR euc-guide-u.tex >euc-guide-k.tex
iconv -f UTF-8 -t EUC-KR kotexguidebody-utf.tex >kotexguidebody-euc.tex
iconv -f UTF-8 -t EUC-KR writinghdoc.tex >writinghdoc-k.tex

