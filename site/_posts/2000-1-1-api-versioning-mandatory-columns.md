---
layout: post
title: "API Versioning: Mandatory Columns"
date: "2019/03/31 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/versioning/header.jpeg"
image: "/assets/images/blog/versioning/header.jpeg"
description: Discover effective strategies to tackle API versioning challenges and ensure data quality without relying on mandatory columns. Learn how to improve user experience, maintain data integrity, and enable seamless back-end upgrades without breaking front-ends.
tags: app-store deployment
categories: [software development]
permalink: /blog/:title
---

There are some difficulties with versioning APIs. One such difficulty is dealing with mandatory columns. If a back-end API upgrade is taking place, and we think that a new mandatory column is needed, we may create a problem for front-ends that don't supply the column. At first, this may seem like an insurmountable problem, but actually, it's not as big a problem as you might think. It may be time to rethink making the column mandatory at all. As programmers, this may seem counter intuitive because the database is the fundamental place for stopping data integrity issues from happening, and mandatory columns guarantee that there will be at least something in the database so that there is no need for checking the value after the record is loaded. However, it may be useful to reorient our thinking about _mandatory_ columns as _seemingly mandatory_ instead.

Please see this article on [Back-end / Front-End Versioning](/back-end-front-end-versioning/).

Data Quality
------------

Poor data is the enemy of quality systems. Quality systems encourage a high level of data quality. Poor systems allow a low level of data quality to fester. For people who design databases, the database usually seems like the logical place for data integrity to be enforced. This is generally true when it comes to referential integrity and so on. If users simply opt to not fill in columns that are necessary for record keeping purposes, the data will degrade in to a poor state. The simple answer seems to be to make columns mandatory when they are necessary for record keeping purposes, but this leads to a problem: form abandonment. This [wikipedia article](https://en.wikipedia.org/wiki/Abandonment_rate) talks about the issue from a marketing perspective, but the issue can be the same in other types of systems.

If a user is confronted with a screen with too many mandatory fields, they may simply not be able to fill the form in. This can lead to them abandoning the record before saving it. This is probably a bigger problem that missing columns. What is worse, a record that is missing a few details? Or, a record that a user never entered because they didn't have all the data? I would argue that the latter is worse. Missing records is a bigger data quality issue than missing _seemingly mandatory_ columns.

Lets take a few scenarios. A customer calls up a call centre, and the operator starts creating a record based on the person's details. There is a mandatory field for date of birth and the operator asks the caller for this information. The caller refuses. The operator saves the record, but the system rejects it. At this point, the operator has the choice of putting in a false date of birth, or to not record the call. Either way, data quality is eroded. The company may have lost an important record because the system didn't allow it to be saved, or incorrect data could have been entered. Perhaps, the date of birth was not so mandatory after all.

In a similar scenario, an issue tracking system may require information like "Steps to reproduce", "Operating system", "Software version" and so on. If a user does not have all this information at their disposal, or does not have time to enter it, the bug will simply not get logged. This is clearly a bigger problem than storing an issue with less information.

The issue of data quality is not as straight forward as it may have seemed when you consider these things.

Moving Away from Mandatory Columns
----------------------------------

As mentioned above, a new mandatory column in an API can break existing front-ends. If an existing front-end does not supply a column that is mandatory in the back-end database, the record either cannot be added to the database, or the record must be added with a default value. Default values negate the usefulness of mandatory columns because a default value doesn't allow you to store whether or not the value was chosen, or just defaulted. So, a different approach is to avoid making mandatory columns at all. You might be thinking, but _how do we improve data quality_?

Actually the answers are probably not as complicated as you think. Have a think about existing systems that you use all the time, [Facebook](https://www.facebook.com/), [LinkedIn](https://www.linkedin.com), [GitHub](https://github.com/), and so on. These systems usually don't force you to fill in data. They give you the ability to fill in as much data as you can, and then encourage you to fill in more with reminders, and gentle nudges as you are using the systems. A good approach is to group up fields and when the user opens the record, and to display a button like "Improve Profile" that directs them to that group of fields. The user will be reminded to increase the quality of the record regularly, and perhaps be given warnings when data is missing.

In scenarios where certain data is required by mandatory reporting purposes there are other steps that can be taken. For example, there may be a government regulation that says that no engagement can be made with a given customer unless your business has a record of their date of birth.  But, notice the business rule here. The business rule isn't that "date of birth is mandatory". The business rule is that "no engagement can be made with a given customer unless your business has a record of their date of birth". So, the system rule would probably stop a user from scheduling an appointment until the date of birth is filled, in, but the original record should not be withheld from the system based on one piece of missing information.

Record statuses like "Complete", "Mostly Complete", or green ticks to indicate completion  can also visually alert the user as to whether or not the data is complete. These calculations can also be used to report on the quality of data and are generally a good idea in most systems where data is critical. These measures can help to orient the systems towards producing higher quality data without stopping users dead in their tracks.

Conclusion
----------

It is best to take a fresh approach to thinking about mandatory columns. Finding other ways to encourage users to fill in data instead of forcing them will allow back-ends to be upgraded without breaking front-ends, but this doesn't need to lead to data integrity issues. Actually, it can make the user experience better, and encourage more data to be captured in the first place.