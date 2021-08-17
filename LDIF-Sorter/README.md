Purpose:
Useful for Import/Export LDAP database in LDIF for backup purpose.

Problem:
I needed a tool that can sort output (no-wrap on) from ldapsearch which then allows me to import back into OpenLDAP.

e.g. ldapsearch -o ldif-wrap=no -Wx -D "cn=admin,dc=example,dc=com" -b "dc=example,dc=com" -H ldaps://ldap1.example.com -LLLLL > ldap_dump.ldif

Tips:
You may need to remove the root entry e.g. "dc=example,dc=com" from ldapsearch dump to prevent exist warning
