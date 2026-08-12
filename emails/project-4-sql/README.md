# Project 4: Ad-hoc Audience Suppression (SQL Engine)

Since SQL queries run internally within SFMC Automation Studio, this project showcases the technical backend data design rather than a visual user interface.

### The Business Problem
The marketing team issued a time-sensitive request to run a high-value promotional push. The requirement was to target guest who have an active contract, but explicitly **suppress** any subscribers flagged as cannotEmail, cannotCall, cannotMail, or cannotSms. It also restricts the audience to vacation ownership members in the USA and in a specific set of states. Finally, the query narrows the result by location and timing. It also excludes subscribers who toured within the last 180 days to prevent post-purchase customer annoyance. 

```mermaid
flowchart TD
    sub[Subscriber_Master_DE] -->|LEFT JOIN on SubscriberKey| tour[Tours_Master_DE]
    sub -->|NOT IN lookup on SubscriberKey| bounce[_Bounce Data View]

    tour -->|Filter: reservationDate >= DATEADD(day, -180, GETDATE())| recentTour[Recent Tours (last 180 days)]
    bounce -->|Filter: EventDate >= DATEADD(day, -30, GETDATE()) and BounceCategory='Hard Bounce'| recentBounce[Recent Hard Bounces]

    sub -->|Audience filters| filtered[Filtered Subscriber Audience]
    recentTour -->|Suppress if match exists| suppressed[Exclude Recent Buyers]
    recentBounce -->|Exclude if match exists| suppressedBounce[Exclude Hard Bounces]

    filtered --> final[Final Eligible Audience]
    suppressed --> final
    suppressedBounce --> final

    style sub fill:#f9f,stroke:#333,stroke-width:2px
    style tour fill:#bbf,stroke:#333,stroke-width:2px
    style bounce fill:#bfb,stroke:#333,stroke-width:2px
    style final fill:#ffd700,stroke:#333,stroke-width:2px
```

## Explanation

- `Subscriber_Master_DE` is the primary source of subscriber profile and contact data.
- `Tours_Master_DE` is left-joined to the subscriber data to identify recent tours.
- The join is restricted to tours in the last 180 days, enabling suppression of recent buyers.
- `_Bounce` is used as an exclusion lookup for hard bounces in the last 30 days.
- The final audience consists of subscribers who pass profile and contact filters, do not have a recent tour match, and are not in the hard bounce suppression list.
