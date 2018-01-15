for a in *.tar.xz
do
    a_dir=`expr $a : '\(.*\).tar.xz'`
    mkdir $a_dir 2>/dev/null
    tar -xvzf $a -C $a_dir
done