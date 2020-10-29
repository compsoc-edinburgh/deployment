name: Docker

on:
  workflow_dispatch:
  push:
    # Publish `master` as Docker `latest` image.
    branches:
      - main

jobs:
  # Push image to GitHub Packages.
  # See also https://docs.docker.com/docker-hub/builds/
  push:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - name: Build image
        run: |
          source .env
          docker build . --file Dockerfile --tag $SUBDOMAIN

      - name: Log into registry
        run: echo "${{ secrets.PAT }}" | docker login ghcr.io -u compsoc-service --password-stdin

      - name: Push image
        run: |
          source .env
          IMAGE_ID=ghcr.io/compsoc-edinburgh/$SUBDOMAIN
          docker tag $IMAGE_NAME $IMAGE_ID:latest
          docker tag $IMAGE_NAME $IMAGE_ID:${{ github.sha }}
          docker push $IMAGE_ID:${{ github.sha }}
          docker push $IMAGE_ID:latest
      - name: Trigger update
        run: |
          curl -H "Token: ${{ secrets.WATCHTOWER_TOKEN }}" https://watchtower.dev.comp-soc.com/v1/update
