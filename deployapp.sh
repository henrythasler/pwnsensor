#!/bin/bash

# created by Henry Thasler (www.thasler.org)
# based on the deploy script by William Hallatt (www.goblincoding.com/contact)

executable="pwnsensor"
qtdir="/opt/Qt/5.2.1/gcc_64"

# Obtain the Linux flavour and version.
distro=`lsb_release -d | awk '{print $2$3$4}' | sed 's/\./_/g'`
echo "OS Version: "$distro

# Create the directory that will be tarred up for distribution.
tardir=`echo $executable"_"$distro | awk '{print tolower($0)}'`
mkdir $tardir
echo "Created tar ball directory: "$tardir

# Copy executable across.
chmod u+x $executable
cp $executable $tardir
echo "Copied executable "$executable" to "$tardir

# Copy qml across.
cp -r "qml" $tardir
echo "Copied qml to "$tardir

cp -r "$qtdir/qml/QtQuick" "$tardir/qml"
cp -r "$qtdir/qml/QtQuick.2" "$tardir/qml"

# Create the libs directory.
libsdir=$PWD/$tardir/libs
mkdir $libsdir
echo "Created libs directory: "$libsdir

# Copy all dependencies across to the tar directory.
echo "Copying dependencies..."

for dep in `ldd pwnsensor | grep "Qt" | awk '{print $3}' | grep -v "("`
do
  cp $dep $libsdir
  echo "Copied dependency "$dep" to "$libsdir
done

# You will need to change this to point to wherever libqxcb.so lives on your PC.
qtplatformplugin="$qtdir/plugins/platforms/libqxcb.so"
qtplatformplugindir=$tardir/platforms
mkdir $qtplatformplugindir
echo "Created platforms directory: "$qtplatformplugindir
cp $qtplatformplugin $qtplatformplugindir
echo "Copied platform "$qtplatformplugin" to "$qtplatformplugindir


# Copy all dependencies across to the tar directory.
echo "Copying platform dependencies..."

for dep in `ldd $qtplatformplugin | grep "Qt" | awk '{print $3}' | grep -v "("`
do
  cp $dep $libsdir
  echo "Copied platform dependency "$dep" to "$libsdir
done


# copy plugins
qtplugins="$qtdir/plugins/imageformats"
qtpluginsdir=$tardir/plugins
mkdir $qtpluginsdir
echo "Created platforms directory: "$qtpluginsdir
cp -r $qtplugins $qtpluginsdir
echo "Copied platform "$qtplugins" to "$qtpluginsdir


# copy additional files
cp "$qtdir/lib/libQt5Widgets.so.5" "$libsdir"
cp "$qtdir/lib/libQt5Svg.so.5" "$libsdir"
cp "$qtdir/lib/libQt5Xml.so.5" "$libsdir"


# Create the run script.
execscript=$tardir/"run$executable.sh"
echo "Created run script: "$execscript

echo "#!/bin/sh" > $execscript
echo "export LD_LIBRARY_PATH=\`pwd\`/libs" >> $execscript
echo "export QML_IMPORT_PATH=\`pwd\`/qml" >> $execscript
echo "export QML2_IMPORT_PATH=\`pwd\`/qml" >> $execscript
echo "export QT_PLUGIN_PATH=\`pwd\`/plugins" >> $execscript

echo "./$executable" >> $execscript

# Make executable.
chmod u+x $execscript

echo "Creating tarball..."
tar -zcvf $tardir".tar.gz" $tardir

#echo "Cleaning up..."
rm -rf $tardir
echo "Done!"
