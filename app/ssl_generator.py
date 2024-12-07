import os
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives import serialization
from cryptography.x509 import Name, NameAttribute
from cryptography.x509 import CertificateBuilder
from cryptography.x509 import BasicConstraints
from datetime import datetime, timedelta
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend
from cryptography.x509.oid import NameOID

# Set the directory to save certificates and keys
cert_dir = "ssl_certs"
if not os.path.exists(cert_dir):
    os.makedirs(cert_dir)

# Generate RSA private key
private_key = rsa.generate_private_key(
    public_exponent=65537,
    key_size=2048,
    backend=default_backend()
)

# Save private key to file
private_key_pem = private_key.private_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PrivateFormat.TraditionalOpenSSL,
    encryption_algorithm=serialization.NoEncryption()
)

with open(os.path.join(cert_dir, "nginx.key"), "wb") as f:
    f.write(private_key_pem)

# Generate self-signed certificate
subject = issuer = Name([
    NameAttribute(NameOID.COUNTRY_NAME, "US"),
    NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, "California"),
    NameAttribute(NameOID.LOCALITY_NAME, "San Francisco"),
    NameAttribute(NameOID.ORGANIZATION_NAME, "My Organization"),
    NameAttribute(NameOID.COMMON_NAME, "nice-assignment.local"),
])

cert = CertificateBuilder().subject_name(subject).issuer_name(issuer).public_key(private_key.public_key()).serial_number(1000).not_valid_before(datetime.utcnow()).not_valid_after(datetime.utcnow() + timedelta(days=365)).add_extension(BasicConstraints(ca=True, path_length=None), critical=True).sign(private_key, hashes.SHA256(), default_backend())

# Save certificate to file
certificate_pem = cert.public_bytes(serialization.Encoding.PEM)

with open(os.path.join(cert_dir, "nginx.crt"), "wb") as f:
    f.write(certificate_pem)

print("SSL certificate and private key generated successfully.")
