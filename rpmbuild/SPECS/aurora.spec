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

%clean
rm -rf $RPM_BUILD_ROOT

%files
/usr/share/applications/
/opt/%{name}
%{_bindir}/%{name}
