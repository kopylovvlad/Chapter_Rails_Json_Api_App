## How to sign_in with curl

### Get current user

```bash
curl -i -H "Accept: application/json" \
  http://localhost:3000/api/sessions/current
```

### Log in (head and body)

```bash
curl --request POST \
  -i -H "Accept: application/json" \
  http://localhost:3000/api/sessions \
  --data "email=user1email@tmail.com&password=super_pass"
```

### Get current user (with cookie)

```bash
curl -i -H "Accept: application/json" \
  -v --cookie "chapter_app=<COOKIE_VALUE>; path=/; HttpOnly" \
  http://localhost:3000/api/sessions/current
```

### Log out

```bash
curl -X "DELETE" \
  -i -H "Accept: application/json" \
  -v --cookie "chapter_app=<COOKIE_VALUE>; path=/; HttpOnly" \
  http://localhost:3000/api/sessions
```
