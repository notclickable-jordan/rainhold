# Lemmy

## Migrate to NotClickable.com

To migrate the Lemmy instance to NotClickable.com, follow these steps:

1. Perform a backup and restore
1. Use the pgAdmin tool at `http://rainhold-beacon:4216` to connect to the database
1. Navigate to `Databases > lemmy > Schemas > public > Tables`
1. Run this query to update the `post` table URLs:
    ```sql
    UPDATE post
    SET url = REPLACE(url, 'starbase80.dev', 'notclickable.com')
    WHERE url LIKE '%starbase80.dev%';
    ```
1. Run these queries to update the `person` table URLs
    1. Update the `avatar` field:
        ```sql
        UPDATE person
        SET avatar = REPLACE(avatar, 'starbase80.dev', 'notclickable.com')
        WHERE avatar LIKE '%starbase80.dev%';
        ```
    1. Update the `actor_id` field:
        ```sql
        UPDATE person
        SET actor_id = REPLACE(actor_id, 'starbase80.dev', 'notclickable.com')
        WHERE actor_id LIKE '%starbase80.dev%';
        ```
    1. Update the `inbox_url` field:
        ```sql
        UPDATE person
        SET inbox_url = REPLACE(inbox_url, 'starbase80.dev', 'notclickable.com')
        WHERE inbox_url LIKE '%starbase80.dev%';
        ```
    1. Update the `inbox_url` field:
        ```sql
        UPDATE person
        SET shared_inbox_url = REPLACE(shared_inbox_url, 'starbase80.dev', 'notclickable.com')
        WHERE shared_inbox_url LIKE '%starbase80.dev%';
        ```
1. Run these queries to update the `site` table URLs:
    1. Update the `icon` field:
        ```sql
        UPDATE site
        SET icon = REPLACE(icon, 'starbase80.dev', 'notclickable.com')
        WHERE icon LIKE '%starbase80.dev%';
        ```
    1. Update the `actor_id` field:
        ```sql
        UPDATE site
        SET actor_id = REPLACE(actor_id, 'starbase80.dev', 'notclickable.com')
        WHERE actor_id LIKE '%starbase80.dev%';
        ```
    1. Update the `inbox_url` field:
        ```sql
        UPDATE site
        SET inbox_url = REPLACE(inbox_url, 'starbase80.dev', 'notclickable.com')
        WHERE inbox_url LIKE '%starbase80.dev%';
        ```
1. Run these queries to update the `community` table URLs:
    1. Update the `actor_id` field:
        ```sql
        UPDATE community
        SET actor_id = REPLACE(actor_id, 'starbase80.dev', 'notclickable.com')
        WHERE actor_id LIKE '%starbase80.dev%';
        ```
    1. Update the `icon` field:
        ```sql
        UPDATE community
        SET icon = REPLACE(icon, 'starbase80.dev', 'notclickable.com')
        WHERE icon LIKE '%starbase80.dev%';
        ```
    1. Update the `followers_url` field:
        ```sql
        UPDATE community
        SET followers_url = REPLACE(followers_url, 'starbase80.dev', 'notclickable.com')
        WHERE followers_url LIKE '%starbase80.dev%';
        ```
    1. Update the `inbox_url` field:
        ```sql
        UPDATE community
        SET inbox_url = REPLACE(inbox_url, 'starbase80.dev', 'notclickable.com')
        WHERE inbox_url LIKE '%starbase80.dev%';
        ```
    1. Update the `shared_inbox_url` field:
        ```sql
        UPDATE community
        SET shared_inbox_url = REPLACE(shared_inbox_url, 'starbase80.dev', 'notclickable.com')
        WHERE shared_inbox_url LIKE '%starbase80.dev%';
        ```
1. Run this query to update the `comment` table URLs:
    1. Update the `ap_id` field:
        ```sql
        UPDATE comment
        SET ap_id = REPLACE(ap_id, 'starbase80.dev', 'notclickable.com')
        WHERE ap_id LIKE '%starbase80.dev%';
        ```
1. Run this query to update the `instance` table URLs:
    1. Update the `domain` field:
        ```sql
        UPDATE instance
        SET domain = REPLACE(domain, 'starbase80.dev', 'notclickable.com')
        WHERE domain LIKE '%starbase80.dev%';
        ```
1. Run this query to update the `image_details` table URLs:
    1. Update the `link` field:
        ```sql
        UPDATE image_details
        SET link = REPLACE(link, 'starbase80.dev', 'notclickable.com')
        WHERE link LIKE '%starbase80.dev%';
        ```
