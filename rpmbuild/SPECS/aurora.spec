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

%define debug_package %{nil}

%prep
%setup -q

%pre
rm -rf /usr/bin/aurora

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p  $RPM_BUILD_ROOT/opt/%{name}
mkdir -p  $RPM_BUILD_ROOT/%{_bindir}
mkdir -p $RPM_BUILD_ROOT/%{_datadir}/applications/
cp %{name} $RPM_BUILD_ROOT/opt/%{name}
cp exec $RPM_BUILD_ROOT/%{_bindir}/%{name}
cp %{name}.desktop $RPM_BUILD_ROOT/%{_datadir}/applications/
cp -R lib $RPM_BUILD_ROOT/opt/%{name}
cp -R data $RPM_BUILD_ROOT/opt/%{name}

%post
chmod +x %{_bindir}/%{name}

%postun
SERVICE="/usr/lib/systemd/system/aurora-controller.service"

if [ -f "$SERVICE" ]; then
    systemctl stop aurora-controller.service >/dev/null 2>&1 || true
    systemctl disable aurora-controller.service >/dev/null 2>&1 || true
    rm -f "$SERVICE"
    systemctl daemon-reload >/dev/null 2>&1 || true
fi


%clean
rm -rf $RPM_BUILD_ROOT

%files
/usr/share/applications/
/opt/%{name}
%{_bindir}/%{name}
