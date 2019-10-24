* [About](#about)
* [Setup](#setup)
* [Settings](#settings)
* [Observer Pattern](#observer_pattern)
* [Performance](#performance) - a small experiment I wanted to do

# About
I will give a brief overview of why I've built this and how it works from a high level soon!

# Setup
> Make sure you have postgresql first (https://postgresapp.com/)
1. run `psql`, then `CREATE TABLE better_jobs;`
2. bundle install
3. run `ruby db/migrations/1_initial_schema.rb` then `ruby db/migrations/2_remove_review_status.rb`

# Settings
All settings can be found in **`config/settings.rb`**. I have mine checked into version control as a example of how to approach the file. Feel free to delete my settings to insert your own.

### Places & Positions
Multiple places and positions can be searched back to back. For example, if you want to search California and Arizona for Software Engineer and Web Developer positions the following searches will take place:
* Searching `California` for `Software Engineer`
* Searching `California` for `Web Developer`
* Searching `Arizona` for `Software Engineer`
* Searching `Arizona` for `Web Developer`

And the settings would look like the following:
```ruby
places: ['California', 'Arizona'],
positions: ['Software Engineer', 'Web Developer'],
```

### Position Exclusions
Position exclusions allows us to completely skip over job postings with certain words in the title, in turn making the search quicker since we don't have to click on and parse irrelevant job postings. Say we don't want positions with `senior` or `php` in the title. The settings would look like the following:

```ruby
position_exclusions: ['senior', 'php']
```

Also, please note position exclusions are **`downcased`**. That is because when the job posting is parsed, it is completely downcased when checking matches.

### Good Keywords
Good keywords allow us to figure out how good a fit this position may be for us. Say we have `passing_points: 50` and we really want beer on tap at our next position (let's be honest, who doesn't). A good approach to this would be the following configuration to make the position pass no matter what if beer is on tap (if there's beer who cares if we have to write c right?
```ruby
# make sure these are all downcased
good_keywords: {'beer on tap': 1_000_000}
```

### Bad Keywords
Setting bad keywords is a great way to exclude keywords that normally wouldn't in the title of the job posting. Say you don't want to match posts from certain company, or onces that want you to work with certain technologies. This is the perfect place for those.
```ruby
# make sure these are all downcased
bad_keywords: {'previous company name': -1_000_000, 'assembly': -1_000_000}
```

### Passing Points
Setting a passing_point setting is related to how you allocate your good and bad keywords. If you set this too high and are too strict on good keywords points, you'll have almost no matches if any. There's a balance. You'll find it young grass hopper.
```ruby
passing_points: 50
```

### Output
```ruby
# Simple output allows you to see a lot of simplified information and is set by default.
simple_ouput: true
```
![](https://github.com/thesimpledev/job_search/blob/master/readme/simple_output.png?raw=true)

* ![](https://github.com/thesimpledev/job_search/blob/master/readme/already_saved.png) Already saved
* ![](https://github.com/thesimpledev/job_search/blob/master/readme/check.png?raw=true) Passed
* ![](https://github.com/thesimpledev/job_search/blob/master/readme/failed.png?raw=true) Failed
* ![](https://github.com/thesimpledev/job_search/blob/master/readme/error.png?raw=true) Some error occurred
* ![](https://github.com/thesimpledev/job_search/blob/master/readme/prime.png) Prime (skipped)
* ![](https://github.com/thesimpledev/job_search/blob/master/readme/title_skip.png) Skipped from title exclusion

```ruby
# More comprehensive output, which can also help with any debugging.
simple_ouput: false
```
![](https://github.com/thesimpledev/job_search/blob/master/readme/non_simple_output.png?raw=true)

# Overserver Pattern
My understanding of the observer patten is you create an initial class which is a blueprint of the API (somewhat of an abstract class) and then have it delegate calls to classes that implement that same API. Insert analogy of a mask that I can't articulate well here.

By using this pattern we increase our amount of lines by about 50%, and add two additional files. But we gain clarity of what each class' purpose is, using the single responsibility principle. We also allow for additional alerters to easily be created in the future. If we were to add another alerter, before using this pattern, we would have a bunch of nested conditionals and ugly branching that's hard to read. Instead, we make the decision 1 time of what we want to use and then use it.
![](https://github.com/thesimpledev/job_search/blob/master/readme/observer.png?raw=true)

# Performance
YAML File Storage w/ Hash Data Structure vs. SQLite3 w/ Active Record

#### Approach

My approach is to use a profiler under different circumstances and see which method performs better. The SQLite3 database has been loaded with records that match all attributes from the objects in the YAML file. In total there are 502 objects in the YAML file and 502 records in the database. I won’t be testing updating records since I test saving them, which I assume will be pretty close in speed. For brevity, I won’t be showing any setup code such as initialization, requiring libraries or classes unless that’s what’s being tested.

#### Predictions

I’m assuming under smaller loads, saving to a file will have better performance, while SQLite3 will perform better under larger loads.

#### Results

#### Thoughts

I was actually shocked at how fast accessing a hash was. Overall I think using a database in combination of a hash once the records are in memory would be a great way to utilize the strengths of the database as well as hashes.

---

### The Tests

#### Pulling all records into memory

File Storage
```ruby  
matches = YAML.load(File.read('./storage/matches.yml'))

# runtime: 0.363s
```

SQLite3
```ruby
job = Job.all

# runtime: 0.084s
```

#### Saving a record

The current method of saving a job to matches overwrites the whole file with the matches. So instead of just saving 1 job at a time, we’re re-saving every single job. This is obviously very inefficient, so I’m assuming there’s going to be a big difference here. In the future, I may test an approach of just appending to the file to see the difference in approach.

Both of the job objects that are being saved in the following examples have the exact same attributes and have been excluded for brevity.

File Storage
```ruby
# storage is a previously initialized Storage object
storage.save_match(job_posting)

# runtime: 0.400s
```

SQLite3 + ActiveRecord
```ruby
Job.create! # same attributes passed as above object

 # runtime: 0.009s
```

#### Finding a record by id

This test is for file storage is actually testing how fast you can access a hash since that’s how the YAML file is setup and how my Storage classes stores the jobs as well.

File Storage
```ruby
job = storage.matches['p_5a9b0d693c9ec826']

# runtime: 0.0000020s
```

SQLite3 + ActiveRecord
```ruby
job = Job.find(1)

# runtime: 0.2s
```

The hash is obviously much faster since we already have all of our data in memory. But of course, if we used `Job.all` and set it up in a hash, we would have the same result as the file storage. So I guess this one isn’t much of a fair test. In reality, the equivalent would be *pulling all records into memory* first and then accessing the hash. Which in that case it takes `0.363s` to pull all the records into memory and then add the time it takes to access a hash. So in reality, the database still wins this one.

(I’m considering revising the above test since it’s not representative…)

#### Finding a record after already finding another record

So when testing finding a record by id, I noticed something with ActiveRecord. When you find a record, the next find call will be much quicker even though you aren’t fetching the same record. 
SQLite3 + ActiveRecord

```ruby
# ran before profiling:
# Job.find(2)

job = Job.find(1)

# runtime: 0.001s
```

As we can see, without the initial query it runs in `0.2s` and after the initial query it runs in `0.001s`, which is 200 times faster. This is a huge optimization and I don’t know why this is, but I’m guessing that after the initial call it also pulls indexes or some information into memory to make the successive calls faster.
