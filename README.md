# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Task

To develop a system where auhor can post new book chapters, and reviewer can add comments to chapters.
To make it more fun, everyone can also add likes to comments.
Chapters can be in these statuses: draft, on review, approved, published.
Only author can change status. Status can’t be changed to “approved” if less than 50% of paticipants commented on it.
Author can also update a chapter. Chapter update generates a special type of comment saying that “chapter was updated”. This comment can’t be liked, and doesn’t counts as a comment when we calculate if 50% people have left feedback.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...
