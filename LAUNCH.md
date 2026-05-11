# Inveris Digital — Launch Guide

This folder is a complete, Vercel-ready static site. Follow the steps below in order; total time is about 30–45 minutes the first time.

## What's in this folder

- `index.html` — the production site (single-page app: home, services, products, iris, insights, contact)
- `404.html` — branded not-found page
- `vercel.json` — clean URL rewrites, security headers, asset caching
- `robots.txt` — search engine directives
- `sitemap.xml` — all six routes for SEO
- `og-image.png` — social share preview (1200x630)
- `logo.svg` — standalone logo file (referenced by JSON-LD)
- `public/` — original v6 PNG screenshots (delete before deploy; not used)
- `inveris-digital-preview-v6.html` — the original V6 file (delete before deploy; not used)

## Step 1 — Wire up the contact form (5 minutes)

The form posts to Formspree. Without this step, contact submissions will fail.

1. Go to https://formspree.io and create a free account using a partner email (e.g., the address that should receive leads).
2. Click **New form**, give it the name "Inveris Digital — inverisdigital.com".
3. Formspree gives you an endpoint that looks like `https://formspree.io/f/abcdwxyz`. Copy the ID (the part after `/f/`).
4. Open `index.html` in a text editor. Find this line:
   ```
   <form class="ct-form" action="https://formspree.io/f/YOUR_FORM_ID" method="POST" novalidate>
   ```
   Replace `YOUR_FORM_ID` with your Formspree form ID. Save the file.
5. The form's first submission will trigger a Formspree confirmation email — click the link to activate.

The free Formspree plan covers 50 submissions/month, which is comfortable for a CXO-targeted advisory site. Upgrade only if volume grows.

## Step 2 — Push the site to GitHub (10 minutes)

Vercel deploys directly from a Git repo. This is also how you'll ship updates later.

1. Create a private repo at https://github.com/new — name it `inverisdigital-com`.
2. From inside this folder, run:
   ```
   git init
   git add .
   git commit -m "Initial production site v1"
   git branch -M main
   git remote add origin https://github.com/YOUR-USERNAME/inverisdigital-com.git
   git push -u origin main
   ```

Before committing, **delete these unused files** from this folder:
- `inveris-digital-preview-v6.html` (the original V6, replaced by `index.html`)
- `index.html.head` (intermediate work file, safe to remove)
- `public/v6-home.png` (4 MB unused screenshot)
- `public/v6-iris.png` (2.5 MB unused screenshot)
- `public/og-image.png` (duplicate; the active one is at the project root)
- `public/test.txt` (empty)

The whole `public/` folder can be deleted — nothing in it is referenced by the site. Keep just the files at the root level. They're harmless if left in but they'd inflate the deploy and don't belong in production.

## Step 3 — Deploy on Vercel (5 minutes)

1. Sign in at https://vercel.com using your GitHub account (so it can see the repo).
2. Click **Add New → Project**.
3. Select your `inverisdigital-com` repo.
4. Vercel auto-detects this as "Other" (static HTML). **Don't** override the build command — leave everything default. Click **Deploy**.
5. In about 30 seconds you'll get a working preview at something like `inverisdigital-com.vercel.app`.

Open the preview, click through every nav link, and submit the contact form once to confirm Formspree delivers an email. If anything's broken, fix locally, commit, push — Vercel auto-redeploys.

## Step 4 — Connect inverisdigital.com (10 minutes)

1. In your Vercel project, go to **Settings → Domains**.
2. Add `inverisdigital.com` and `www.inverisdigital.com`. Vercel will tell you which DNS records to set.
3. At your domain registrar (whoever you bought the domain from):
   - For the apex/root `inverisdigital.com`, add an **A record** pointing to `76.76.21.21`.
   - For `www.inverisdigital.com`, add a **CNAME record** pointing to `cname.vercel-dns.com`.
   - If your registrar supports it, also enable **CAA records** for `letsencrypt.org` and `digicert.com` (Vercel issues SSL certs through them).
4. DNS typically propagates in 5–30 minutes. Vercel auto-issues a free Let's Encrypt SSL cert as soon as it sees the records resolve.

After SSL is green, set the redirect direction in Vercel: pick `inverisdigital.com` (or `www.`) as primary, and Vercel will 308-redirect the other to it. CXO best practice is the apex (no www).

## Step 5 — Verify the launch (10 minutes)

Run through this checklist on the live domain:

- [ ] HTTPS works and shows a valid cert
- [ ] Both `https://inverisdigital.com` and `https://www.inverisdigital.com` work (one redirects to the other)
- [ ] Direct URLs work: `/services`, `/products`, `/iris`, `/insights`, `/contact`
- [ ] Mobile menu opens/closes (resize browser to under 860px or open DevTools mobile mode)
- [ ] Contact form submits and you receive the email at the Formspree-registered address
- [ ] Share preview looks right: paste `https://inverisdigital.com/` into LinkedIn, Slack, or https://www.opengraph.xyz/ — should show the OG card with brand colors
- [ ] Submit your sitemap to Google: https://search.google.com/search-console → add property `inverisdigital.com` → verify (Vercel can do this via DNS) → submit `sitemap.xml`

## Updating the site later

The Git push you did in Step 2 is now the source of truth. To make changes:

1. Edit files locally
2. `git add . && git commit -m "Update copy on services page"`
3. `git push`

Vercel deploys automatically in ~30 seconds and gives you a unique preview URL for every push so you can review before the change hits production.

## What this setup gives you

- **Credibility**: Vercel's edge network is what OpenAI, Notion, and Stripe sit on. CTOs recognize the brand.
- **Speed**: Static HTML on a global CDN means every page loads in well under a second from anywhere on earth.
- **Scale**: This setup handles a single visitor or the front page of Hacker News with no config change.
- **Cost**: $0 on Vercel's Hobby plan (private repo, unlimited bandwidth on a single domain, free SSL). If you ever need team access controls or analytics, Vercel Pro is $20/user/month.
- **Security headers**: HSTS preload, X-Frame-Options, Permissions-Policy already configured in `vercel.json`. You'll score A+ on https://securityheaders.com out of the box.
- **SEO**: Open Graph + Twitter cards + JSON-LD Organization schema + sitemap + robots.txt. Google can index every route.

## Where to invest next

In rough priority order:

1. **Plausible or Fathom analytics** (privacy-friendly, GDPR-clean — better fit for the audience than GA4). One-line script add to `<head>`. ~$9/month.
2. **Calendly link in the contact page** so the lead can self-book a 30-minute call instead of waiting on the email exchange.
3. **A real Insights post** (replace the placeholder articles) — pick the strongest CXO-level POV from your current insights and publish it as a deeper read.
4. **Logos/proof bar** — once you have 3–4 client logos you can publish, add a logo strip below the hero. Anonymous outlines work too, e.g., "Series B MedTech, $400M cap. 18-mo FDA timeline."
5. **Custom Vercel domain for previews** — instead of `inverisdigital-com.vercel.app`, use `staging.inverisdigital.com` for branch deploys.

That's it. The site is engineered for credibility with senior healthcare-and-life-sciences buyers; the deploy stack is what they'd expect a serious technology partner to use themselves.
