Name:           aurora
Version:        aurora_ver
Release:        1%{?dist}
Summary:        A utility to control keyboard back-light and charging threshold for Asus TUF-gaming series laptop
BuildArch:      x86_64
URL:            https://github.com/legacyO7/aurora
License:        GPLv3
Source0:        %{name}-%{version}.tar.gz

Requires:       bash, polkit

%description
A utility to control keyboard back-light and charging threshold for Asus TUF-gaming series laptop

%prep
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p  $RPM_BUILD_ROOT/opt/%{name}
mkdir -p $RPM_BUILD_ROOT/%{_datadir}/applications/
cp %{name} $RPM_BUILD_ROOT/opt/%{name}
cp -R lib $RPM_BUILD_ROOT/opt/%{name}
cp -R data $RPM_BUILD_ROOT/opt/%{name}

cat > $RPM_BUILD_ROOT/%{_datadir}/applications/%{name}.desktop <<'EOF'
[Desktop Entry]
Name=Aurora
Comment=A utility to control keyboard back-light and charging threshold for Asus TUF-gaming series laptop
Exec=%{_bindir}/%{name}
Icon=/opt/%{name}/data/flutter_assets/assets/images/icon.png
Terminal=false
Type=Application
Categories=Utility;
EOF


%post
rm -rf  %{_bindir}/%{name}
cat > %{_bindir}/%{name} <<'EOF'
#!/bin/sh

aurora_bin=/opt/aurora/aurora
pre_cmd=''
post_cmd=''


runAurora(){
    $pre_cmd $aurora_bin $post_cmd
}


if [ $# -ne 0 ];  then

   if [[ "$@" == *"--log"* ]]; then
    post_cmd='--log'
   fi

   if [[ "$@" == *"--with-root"* ]]; then
    pre_cmd="pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY"
   fi

   if [[ "$@" == *"--help"* ]]; then
echo "usage: --log          -       enables logging
       --with-root    -       runs with eleavated privilages
       --help         -       helps!"
   else
    runAurora
   fi
else
    runAurora
fi
EOF
chmod +x %{_bindir}/%{name}

%clean
rm -rf $RPM_BUILD_ROOT

%files
/usr/share/applications/
/opt/%{name}
