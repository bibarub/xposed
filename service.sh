until [[ $(getprop dev.bootcomplete) == "1" ]]; do sleep 1; done
sleep 5
pm path de.robv.android.xposed.installer && exit
cp -f ${0%/*}/XposedInstaller.apk /data/local/tmp
pm install /data/local/tmp/XposedInstaller.apk &> /data/local/tmp/1.txt
rm /data/local/tmp/XposedInstaller.apk
