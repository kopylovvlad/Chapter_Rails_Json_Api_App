## ChapterApp

It is an app for RailsHurts project.

## Task

To develop a system where auhor can post new book chapters, and reviewer can add comments to chapters.
To make it more fun, everyone can also add likes to comments.
Chapters can be in these statuses: draft, on review, approved, published.
Only author can change status. Status can’t be changed to “approved” if less than 50% of paticipants commented on it.
Author can also update a chapter. Chapter update generates a special type of comment saying that “chapter was updated”. This comment can’t be liked, and doesn’t counts as a comment when we calculate if 50% people have left feedback.

## Progress

- [x] Registration
- [x] Session
- [x] Users (index, show)
- [x] Chapter CRUD
- [ ] Comment CRUD
- [ ] ChapterComment (index)
- [ ] Chapter::Like CRUD
- [ ] Chapter workflow with state-machine

## Documentation

```
rails s
open localhost:3000/apipie
```

## How to Up

```bash
rails db:setup
rails s
```

## Tests

```bash
rspec spec/
```

## TODO

- delete scaffold
- deploy to Heroku
