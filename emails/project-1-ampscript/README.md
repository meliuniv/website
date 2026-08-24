# Project 1: Dynamic Content Blocks

Since this code runs on GitHub Pages, the following 
simulate the fields that would naturally pull from an SFMC Data Extension rather than a visual email.

### The Business Problem
The marketing team wanted to send to users based on real-time journey data without creating dozens of separate emails.


## Explanation
- `SET statements` are only for local testing and should be removed or conditionalized before a real send so live DE values populate at send time.

- `greeting logic` uses EMPTY(@FirstName) to defensively detect missing first names and sets @Greeting to "Valued Member" when the field is blank; otherwise it uses the provided @FirstName. This prevents blank greetings in the HTML where %%=v(@Greeting)=%% is injected inside the h1 tag.

- `asset routing` section branches on @membershipType to pick a hero image and a CTA button color. Platinum, Points, and an else branch (fallback) map to different @HeroImage and @ButtonColor values; those variables are then injected into the HTML for the img src="..." tag and the table cell bgcolor. 