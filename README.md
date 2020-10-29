# Deploying a CompSoc service

So you want to run a CompSoc service? Wonderful! You'll need to be part of the `SigWeb` team on GitHub for this to work, and will need to have added your SSH keys to GitHub. An implementation detail here is that keys are synced at most every 30 minutes, so you may need to wait that long after being added to the team. If you're not part of the team, but would _like_ to be, file an issue on the template repository.

It's pretty simple to get started with a new service, just follow these steps:

1. Use this template repository to create a template within `compsoc-edinburgh` where your app will live.
2. Clone it
3. Should your app be committee only? That's the default behaviour, but if you want it to be public delete line `28` in the `makefile`
4. Modify `.env` with your app's options

   - `SUBDOMAIN=...`: Which subdomain of `dev.comp-soc.com` should this app run on. This should be a valid subdomain string.

5. Add, commit, and push
6. You'll need to enable GitHub Actions for the repository, and you'll need to trigger a manual run of the `Deploy` action
7. Run `make initialise`
8. And you're done! This template presumes a NodeJS app, but you'd be able to use any technologies to build your app, as long as:
   1. You can package it in a _single_ docker container
   2. It listens on at most _one_ port, specified by the `$PORT` environment variable

Your app is now setup with deployment on push, automatic HTTPS, and (unless you diabled it) is behind CompSoc's GSuite authentication layer.

# FAQ

_I mean, these aren't frequently asked **yet**, but they may be in future_

## Can I use cool stuff like databases?

Absolutely! Postgres is automatically supported (check the `$DATABASE_URL` environment variable for the connection string), and other can be supported as and when needed (just file an issue in the template repository)

## What about secrets? I don't want those in `git`!

You absolutely don't, which is why secrets management is built in. When you run `make initialise`, a directory `.secrets` will be created, which isn't checked in to git. Everything in that directory is available to your running application at the path `/secrets`. To re-sync secrets after you've changed the contents of `.secrets`, just run `make sync-secrets`. You can stick anything in here, from `json` config files to private signing keys.

## Object storage support?

Yep, check the `$FILE_UPLOAD` environment variable. It contains a URL that you can send a `GET` request to, with a `Content-Type` header set to indicate your file's type. The response will be:

```json
{
  "upload_url": "https://...", // A signed upload URL that you can use yourself, or pass to a client
  "accessible_at": "https://cdn.comp-soc.com/..." // The URL at which your blob will be accessible once uploaded — to be stored in your database
}
```

## What if my app crashes in production?

No worries, you can sort it — CompSoc believes in you! Just run `make tail` to stream the current production logs from your app into your terminal, or `make logs` to get a dump of all your app's logs since initialisation (note, this can be a _lot_ of data, so use `make tail` where you can).

## I have another question?

File an issue in the template repository, and we'll get to it as soon as possible.

## I'd like to develop locally

That's a good shout. You will need to have `docker` and `docker-compose` installed, but after that a simple `make dev` should get you running locally. Well, it will at _some_ point anyway — it doesn't quite yet...
