# PaperTrail HashDiff Adapter

Adapter for the popular versioning/auditing tool [PaperTrail](https://github.com/paper-trail-gem/paper_trail)
This gem allows you to store only incremental changes in the object_changes column.
This is especially useful when you are storing hashes in a json/b column and would like to track changes for each key.
Uses [HashDiff](https://github.com/liufengyun/hashdiff)

## Usage

Add the gem 'paper_trail-hashdiff' to your Gemfile.

In your paper_trail.rb initializer, add the following:
```ruby
require 'paper_trail_hashdiff'
PaperTrail.config.object_changes_adapter = PaperTrailHashDiff.new
```

Additionally, if you want to limit storing these changes for only object columns (eg. json hashes or arrays) and skip primitives, you can use the "only_objects" option when initializing:
```ruby
PaperTrail.config.object_changes_adapter = PaperTrailHashDiff.new(only_objects: true)
```
Note: With this option, the ```where_object_changes``` method from PT may not work properly.

## Storage format

say you have a jsonb column called 'custom_values' as follows:
```
{
  name: 'abc'
  age: 5,
  tags: ['a', 'b']
}
```
and it is changed to
```
{
  name: 'def'
  age: 5,
  tags: ['a', 'c']
}
```

Previously the object_changes column would have been stored as follows:
```
{
  custom_values: [
    {
      name: 'abc',
      age: 5,
      tags: ['a', 'b']
    },
    {
      name: 'def',
      age: 5,
      tags: ['a', 'c']
    }
  ]
}

```

With this change, it will be stored as follows:
```
{
  custom_values: [
    ["~", [:name], "abc", "def"], ["-", [:tags, 1], "b"], ["+", [:tags, 1], "c"]
  ]
}
```

As you can see, the keys that were not changed (i.e. in this case, age) will not appear in the object changes at all, thus increasing storage efficiency.
