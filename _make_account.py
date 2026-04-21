import hashlib, secrets, sys

def srp6_verifier(username, password):
    username = username.upper()
    password = password.upper()
    salt = secrets.token_bytes(32)
    g = 7
    N = int('894B645E89E1535BBDAD5B8B290650530801B18EBFBF5E8FAB3C82872A3E9BB7', 16)
    h1 = hashlib.sha1((username + ':' + password).encode()).digest()
    h2 = hashlib.sha1(salt + h1).digest()
    x = int.from_bytes(h2, 'little')
    v = pow(g, x, N)
    v_bytes = v.to_bytes(32, 'little')
    return salt.hex().upper(), v_bytes.hex().upper()

u, p = sys.argv[1], sys.argv[2]
salt, verifier = srp6_verifier(u, p)
print(f"{salt}|{verifier}")
