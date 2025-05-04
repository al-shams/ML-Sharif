**[Back to Index](../README.md)**

**Useful Command:**

```shell
sudo apt install gnupg
```

```shell
gpg --full-generate-key
```

```shell
gpg --export --armor <fingerprint> > public-key.asc
```

```shell
gpg --export-secret-keys --armor <fingerprint> > private-key.asc
```

```shell
gpg --output revoke-cert.asc --gen-revoke <fingerprint>
```

```shell
gpg --import /private-key.asc
```

```shell
gpg --import /public-key.asc
```

```shell
gpg --list-keys
```

```shell
gpgconf --launch gpg-agent
```

```shell
gpg-connect-agent /bye
```

```shell
gpgconf --kill gpg-agent
```
