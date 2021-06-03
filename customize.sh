SKIPUNZIP=1

# Print module name
ui_print "*******************************"
ui_print "Xposed framework installer zip "
ui_print "*******************************"


ui_print "- Extracting module files"
if [ $API -ge 26 ]; then
  XVERSION="90-beta3"
  XPOSEDBRIDGE="XposedBridge.90.jar"
else
  XVERSION="89"
  XPOSEDBRIDGE="XposedBridge.89.jar"
fi
unzip -o "$ZIPFILE" "post-fs-data.sh" -d $TMPDIR >&2
unzip -o "$ZIPFILE" "$API/$ARCH/*" -d $TMPDIR >&2
unzip -o "$ZIPFILE" "module.prop" -d $TMPDIR >&2
unzip -o "$ZIPFILE" "common/$XPOSEDBRIDGE" -d $TMPDIR >&2
unzip -o "$ZIPFILE" "common/XposedInstallerMagisk.apk" -d $TMPDIR >&2

XPOSEDDIR=$TMPDIR/$API/$ARCH
[ -d $XPOSEDDIR ] || abort "! Unsupported device"

ui_print "- Xposed version: $XVERSION"
ui_print "- Device platform: $ARCH"

ui_print "- Copying files"
cp $TMPDIR/post-fs-data.sh $MODPATH
mkdir -p $MODPATH/system/framework
cp $TMPDIR/common/$XPOSEDBRIDGE $MODPATH/system/framework/XposedBridge.jar
cp -af $XPOSEDDIR/system/. $MODPATH/system
mkdir -p $MODPATH/system/app/XposedInstallerMagisk
cp $TMPDIR/common/XposedInstallerMagisk.apk $MODPATH/system/app/XposedInstallerMagisk/XposedInstallerMagisk.apk
cat << EOF > $MODPATH/xposed.prop
version=${XVERSION}
arch=${ARCH}
minsdk=${API}
maxsdk=${API}
EOF
[ $API -ge 26 ] && echo "requires:fbe_aware=1" >> $MODPATH/xposed.prop
cp $TMPDIR/module.prop $MODPATH


set_perm_recursive $MODPATH 0 0 0755 0644

set_perm_recursive  $MODPATH/system/bin           0   2000    0755    0755
set_perm_check  $MODPATH/system/bin/app_process32       0   2000    0755    u:object_r:zygote_exec:s0
set_perm_check  $MODPATH/system/bin/app_process64       0   2000    0755    u:object_r:zygote_exec:s0
set_perm_check  $MODPATH/system/bin/dex2oat             0   2000    0755    u:object_r:dex2oat_exec:s0
set_perm_check  $MODPATH/system/bin/patchoat            0   2000    0755    u:object_r:zygote_exec:s0
set_perm_check  $MODPATH/system/bin/dexoptanalyzer      0   2000    0755    u:object_r:dexoptanalyzer_exec:s0
set_perm_check  $MODPATH/system/bin/profman             0   2000    0755    u:object_r:profman_exec:s0

set_perm_check() {
  [ -f "$1" ] || return
  set_perm "$@"
}
