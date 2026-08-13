/*******************************************************************************
PROJECT: Ad-Hoc Audience Segmentation
AUTHOR: Melissa Franck
ENGINE: Salesforce Marketing Cloud (SFMC) SQL 
DESCRIPTION: Compiles a subscriber list for an ad-hoc 
             promotional campaign. Combines core profiles, engagement metrics, 
             and immediate real-time suppression logic.
*******************************************************************************/

SELECT
    sub.subscriberKey,
    sub.emailAddress,
    sub.firstName,
    sub.lastName,
    sub.city,
    sub.state,
    sub.country,
    recentTour.reservationDate

FROM
    [Subscriber_Master_DE] AS sub


LEFT JOIN
    [Tours_Master_DE] AS recentTour
    ON sub.subscriberKey = recentTour.subscriberKey
    /* Match only tours within the last 180 days so we can suppress recent buyers */
    AND recentTour.reservationDate >= DATEADD(day, -180, GETDATE())


WHERE
    /* Target only active loyalty tiers */
    sub.contractStatus = 'Active'
    AND sub.memberType IN ('Legacy', 'Points', 'Premium')

    /* Exclude hard bounces over the last 30 days */
    AND sub.SubscriberKey NOT IN (
        SELECT b.SubscriberKey 
        FROM [_Bounce] AS b 
        WHERE b.EventDate >= DATEADD(day, -30, GETDATE()) 
          AND b.BounceCategory = 'Hard Bounce')

    /* Suppress those who have toured the last 180 days*/
    AND recentTour.SubscriberKey IS NULL 

    /*additional segmentation criteria */
    AND
        sub.emailAddress IS NOT NULL
        AND
        sub.emailAddress != ''
        AND
        sub.cannotEmail = 'false'
        AND
        sub.cannotCall = 'false'
        AND
        sub.cannotMail = 'false'
        AND
        sub.cannotSms = 'false'
        AND
        sub.productType = 'vacation ownership'
        AND
        sub.country = 'United States'
        AND
        sub.state IN ('FL','CA','NY','NV','HI');

    


