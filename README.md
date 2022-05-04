1 Install ruby 3.1.2 with bundler gem

2 Run `bundle install`

3 Add constants to Rails custom credentials

```
airtable:
  api_key: <YOUR AIRTABLE API KEY>
  base_key: <YOUR AIRTABLE WORKSPACE KEY>
  table_id: <YOUR AIRTABLE TABLE ID>
```

Run `bin\rails copy:import` to import airtable copies

Start rails by running command `bin\rails s`

API endpoints:

`/copy` - returns all the copy in JSON format

`/copy?since=1604352707` - only returns copy data changes after the since param

`/copy/{key}` - returns the correct value associated with the key

`/copy/refresh` - refresh the copy data in the backend server
