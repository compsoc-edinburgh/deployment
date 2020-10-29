# Deploying a CompSoc service

So you want to run a CompSoc service? That's great! (less work for the TechSec & SigWeb...). It's pretty simple to get started, just follow these steps:

1. Use this template repository to create a template within `compsoc-edinburgh` where your app will live.
2. Clone it
3. Modify `.env` with your app's options
   - `SUBDOMAIN=...`: Which subdomain of `dev.comp-soc.com` should this app run on. This should be a valid subdomain string.
   - `INTERNAL=...`: Is this an internal committee service?
4. Add, commit, and push
5. You'll need to enable GitHub Actions for the repository, and you'll need to trigger a manual run of the `Initialise` action
6. And you're done! This template presumes a NodeJS app, but you'd be able to use any technologies to build your app, as long as:
   1. You can package it in a _single_ docker container
   2. It listens on at most _one_ port, specified by the `$PORT` environment variable

Your app is now setup with deployment on push, automatic HTTPS, and (if you specified in `deployment.toml`) is behind CompSoc's GSuite authentication layer.

# FAQ

_I mean, these aren't frequently asked **yet**, but they may be in future_

## Can I use cool stuff like databases?

Absolutely! Postgres is automatically supported (check the `$POSTGRES_URL` environment variable for the connection string), and other can be supported as and when needed (just file an issue in the template repository)

## What if my app crashes in production?

No worries, you can sort it — CompSoc believes in you! Just run `make tail` to stream the current production logs from your app into your terminal, or `make logs` to get a dump of all your app's logs since initialisation (note, this can be a _lot_ of data, so use `make tail` where you can). You'll need to be part of the `SigWeb` team on GitHub for this to work, and will need to have added your SSH keys to GitHub. An implementation detail here is that keys are synced at most every 30 minnutes, so you may need to wait that long after being added to the team. If you're not part of the team, but would _like_ to be, file an issue on the template repository.

## I have another question?

File an issue in the template repository, and we'll get to it as soon as possible.

## I'd like to develop locally

That's a good shout. You will need to have `docker` and `docker-compose` installed, but after that a simple `make dev` should get you running locally
