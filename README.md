# my-angular-app

## Docker + Nginx (production build)

This repo includes:

- **`dockerfile`**: multi-stage Docker build (Node builds Angular, Nginx serves static files)
- **`nginx.conf`**: Nginx config with `try_files` to support Angular client-side routing

### Build the image (local)

```bash
docker build -f dockerfile -t my-angular-app:latest .
```

### Run the container (local)

```bash
docker run --rm -p 8080:80 my-angular-app:latest
```

Then open `http://localhost:8080`.

### What the files do

- **`dockerfile`**
  - Builds the Angular app via `npm run build`
  - Copies the build output from `dist/my-angular-app/browser` into Nginx at `/usr/share/nginx/html`
  - Replaces the default Nginx site config with `nginx.conf`

- **`nginx.conf`**
  - Serves `index.html` for unknown routes:
    - `try_files $uri $uri/ /index.html;`

### Optional: build & push with buildx

See **`docker-build.md`** for the `docker buildx` command to build for `linux/amd64` and push to a registry.

### Deploy flow (Docker Hub → EC2)

- **Build the image** (locally/CI) and **push to Docker Hub**
- On the **EC2 instance** (with Docker installed/running), **pull the same image** from Docker Hub and run it

Example on EC2:

```bash
docker pull <dockerhub-username>/<image-name>:latest
docker run -d --restart unless-stopped -p 80:80 <dockerhub-username>/<image-name>:latest
```
