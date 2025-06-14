# Lemmy

## Migrate to NotClickable.com

To migrate the Lemmy instance to NotClickable.com, follow these steps:

1. Perform a backup and restore
1. Use the pgAdmin tool at `http://rainhold-beacon:4216` to connect to the database
1. Navigate to `Databases > lemmy > Schemas > public > Tables`
1. Run this query:
    ```sql
    UPDATE post
    SET url = REPLACE(url, 'starbase80.dev', 'notclickable.com')
    WHERE url LIKE '%starbase80.dev%';
    ```
