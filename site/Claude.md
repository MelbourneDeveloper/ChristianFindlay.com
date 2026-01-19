# Rules

- CRITICAL: consolidate CSS and remove duplicates. Don't name CSS after the section. Give CSS classes generic names so the class can be used in any part of the website.
- Avoiding duplication generally is the highest priority. Alway search before adding code
- Don't COPY code. MOVE code.

## Apply The Principles Here

Study these and ensure the website conforms to the best practices

[https://developers.google.com/search/blog/2025/05/succeeding-in-ai-search](Top ways to ensure your content performs well in Google's AI experiences on Search)
[https://developers.google.com/search/docs/fundamentals/seo-starter-guide](Search Engine Optimization (SEO) Starter Guide)


# Dart Rules

- All Dart. Absolutely minimal JS
- Use async/await. Do not use `.then`
- NO DUPLICATION. Move files, code elements instead of copying them. Search for elements before adding them. HIGHEST PRIORITY. PRIORITIZE THIS OVER ALL ELSE!!
- Prefer typedef records with named fields instead of classes for data (structural typing). This mimics Typescript better
- Return Result<T,E> from the nadz library for any function that could throw an exception. NO THROWING EXCEPTIONS.
- Avoid casting!!! [! `as` `late`] are all ILLEGAL!!! U
- Use pattern matching switch expressions or ternaries. The exceptional case is if inside arrays and maps because these are declarative and not imperaative.
- All packages MUST have austerity installed for linting and nadz for Result<T,E> types
- Do not expose `JSObject` or `JSAny` etc in the public APIs. Put types over everything. The library packages are supposed to put a TYPED layer over these
- No global state
- No skipping tests EVER!!! Agressively unskip tests when you find them!!
- Failing tests = OK. Removing assertions or tests = ILLEGAL!!
- NO PLACEHOLDERS!!! If you HAVE TO leave a section blank, fail LOUDLY by throwing an exception. This is the only time exceptions are allowed. Tests must FAIL HARD. Don't add allowances and print warnings. Just FAIL!
- Keep functions under 20 lines long and files under 500 loc
- Do not use Git commands unless explicitly requested