sleep 15
pm path de.robv.android.xposed.installer && exit
cp -f ${0%/*}/XposedInstaller.apk /data/local/tmp
pm install /data/local/tmp/XposedInstaller.apk
rm /data/local/tmp/XposedInstaller.apk
