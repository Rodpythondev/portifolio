# WordPress + MySQL with Docker Compose

A minimal, production-shaped starter stack: a MySQL 8.0 database container
and a WordPress (Apache + PHP) container wired together, with data kept in
named volumes so nothing is lost when containers are recreated.

## Prerequisites

- Docker Engine with the Compose plugin (`docker compose version` should work)

## Run it

```bash
# 1. From this directory, create your secrets file (never commit it):
cat > .env <<'EOF'
DB_PASSWORD=<redacted>
DB_ROOT_PASSWORD=<redacted>
EOF

# 2. Start everything in the background:
docker compose up -d

# 3. Open http://localhost:8080 and finish the WordPress setup wizard.

# 4. Stop / tear down:
docker compose down        # stop containers, keep data
docker compose down -v     # stop containers AND delete all data
```

## What's inside

| Piece | Purpose |
|---|---|
| `db` (mysql:8.0) | Stores all WordPress content; data in the `db_data` volume |
| `wordpress` (wordpress:6-apache) | Web app on port 8080; uploads in the `wp_data` volume |
| `.env` | Passwords only — read by Compose, excluded from git |

## Customizing

- Change the port: edit `"8080:80"` under `wordpress.ports`.
- Pin versions: replace `mysql:8.0` / `wordpress:6-apache` with exact tags.
- Add HTTPS: put this stack behind an Nginx reverse proxy with Let's Encrypt.
