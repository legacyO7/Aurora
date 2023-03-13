Name:           aurora
Version:        aurora_ver
Release:        1%{?dist}
Summary:        A utility to control keyboard back-light and charging threshold for Asus TUF-gaming series laptop
BuildArch:      x86_64
URL:            https://github.com/legacyO7/aurora
License:        GPLv3
Source0:        %{name}-%{version}.tar.gz

Requires:       bash

%description
A utility to control keyboard back-light and charging threshold for Asus TUF-gaming series laptop

%prep
echo RPM_BUILD_ROO === $RPM_BUILD_ROOT
echo bindir === %{_bindir}
echo datadir === %{_datadir}
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/%{_bindir}/%{name}
mkdir -p $RPM_BUILD_ROOT/%{_datadir}/applications/
cp %{name} $RPM_BUILD_ROOT/%{_bindir}/%{name}
cp -R lib $RPM_BUILD_ROOT/%{_bindir}/%{name}
cp -R data $RPM_BUILD_ROOT/%{_bindir}/%{name}

cat > $RPM_BUILD_ROOT/%{_datadir}/applications/%{name}.desktop <<'EOF'
[Desktop Entry]
Name=Aurora
Comment=A utility to control keyboard back-light and charging threshold for Asus TUF-gaming series laptop
Exec=%{_bindir}/%{name}/%{name}
Icon=%{_bindir}/%{name}/data/flutter_assets/assets/images/icon.png
Terminal=false
Type=Application
Categories=Utility;
EOF

%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/%{name}
/usr/share/applications/
