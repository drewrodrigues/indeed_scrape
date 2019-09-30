* [Setup](#setup)
* [Performance](#performance)

## Setup
I will be adding information on how to set this up soon! :D

## Performance
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
