#!/bin/bash

if [ ! -f scripts.env ]; then
  echo "Error: setup_gpg_public_key.sh must be executed inside the scripts directory."
  exit 1
fi

source scripts.env

PRINTLN "Setting up GPG public key..."

echo "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

mQENBEwb1h4BCAC9mXNJZYsYSlP6PN//UC7lw4Bb1ndfjqi5Fn4a7na79JNWMvuf
mOprl88Ah4+hcuq6jqtcJ7+USLbO1OqjPyGmJIoMmwGmelt/B9BPDaOMv6oGduY8
gohOP8bIeQnEEfyFpC2JccEQ4cIidN+CKk92L+TxCVy44aP08cLr6t6SdD9nA7+d
AJEFIy9RsQ3FmJwoDqprQvgR5VYa0BUBDFJo+yfTt85RX7/QOGv+V/gj9n3axz2X
n2hlo/WAO8uUb9GM4S4rRLyCp/d8Pu76JhUELjLkDscTsYQEA7LrrRpourZ891bg
ATEc5mdfdh/68jaUD310pI1AZivXZ3JzUddRABEBAAG0HUlsYW4gU21pdGggPGx1
bm55c0BnbWFpbC5jb20+iQE4BBMBAgAiBQJMG9YeAhsDBgsJCAcDAgYVCAIJCgsE
FgIDAQIeAQIXgAAKCRCWgbiplC/V4BeVB/9lp9VGFOZeIwcJxUAs0MhMvpQx9IW0
5l7RlJH+nIGkt+EiUsYWphFSr2xOAwfTlU8i+utyz1qSX1bi/l991wrCDglfBrg8
4AFCTUkNJJcfFSgHcJ3p7V1qlT4+XJpB6po+/18V4FMOQJn5PeMGmNvTMr2wh5Hh
yEZVk8BT1qdB5I8fzlYXXe8DD2QV1dMon+4oXufYGxVXY6sl0MAk279x+xRRqVef
2wYdDtq7hXxS+ns+VK3hZRrFpG6YSVY8fbByDvyJRLZgZkiH2pbeX6c9j1C2jsWP
NoRe0+FbG0JU+HWR5WKk5vmoYGnZmoi+2bVElJNEmkKJMKuRxAyXetZIuQENBEwb
1h4BCADXUjOrtYqY7dWMvzdZ8sIaysJUUPxz2QClb3d5mLjTXAqojmLa5Ke69+P2
wSXkZ7ukWexhjcmd/m7iGo7p0+DX1SlP4zCk3nZv/Fi8f7+HDLbwXEHZNd7TQ6yr
Zn02YQgWqy8At1pmN0tgruQRWNrf2f1fGtjYqD2JylCLoz3zQW5aE+lg74aQW8mq
nHp3KTgelQLZE3zO/7L+w9zRGdAUt6WtZjCEEUKbbrKOced3RLydQodjKAm75xO1
N6rgSzDloTjOZeTKczPbOT8yvtIvcyFnc/vIcFiTIHHAyk7ZVSs+/hNodXOQHhfg
czB3naxwTMR/tKB2qC2v+0DaeSQLABEBAAGJAR8EGAECAAkFAkwb1h4CGwwACgkQ
loG4qZQv1eAb7gf/SHoF8CaFIXOMtA1Z4QoTKLuAFKwF8Q0OVp4tCObma/UZSogc
cxbtlunM9+fNHVvtxgMlaujlqiVSWkDjKSFWkdqvxlQT1pk4nJmopzqWFFyYc9/5
Qt8ifoigrMsvN4zi5EfqYsRz0DTCoW+AmoELmZeATivjNakck6fme0OwUacotqMa
YXKImYVXt3d4KtBF3+W8K66qS/motGNh4qpH28AJ6zuIXaXtUhTKo+uk/QdX7wls
9VikcFgz6rOJRFxQeRb/IQ3q3hfMRGWMEuHdYZLJDYxvRPnLq3VMQV0yl4glSXfA
sHSMazqkbFkBwlug3U9a8I3VvgNwcBAI+z+jnw==
=kRuK
-----END PGP PUBLIC KEY BLOCK-----" | gpg --import

