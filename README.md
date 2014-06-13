# Fileship 2.0.0

## Features
* Feedback integrated with Redmine
* CAS authentication
* Automatic deletion of old files
* Supports individual files up to 250MB in size
* Share files with anyone on the internet
* Supports all major browsers

## Introduction
Fileship provides a fun, simple way to share files with friends and peers without using third party storage. 

While Fileship works best with Javascript-enabled browsers, its graceful degredation allows it on old school browers as well.


Once you upload a file, you can share it with anybody by giving them a generated URL. 


## Configurations
Fileship's configurations are in 'config' -> 'app.yml'.

* Fileship uses CAS for user authentication, and LDAP for adding users. Be sure to set these up correctly!

* User feedback is integrated with Redmine to automatically generate issues. Fileship will still work if you don't use Redmine, but users won't be able to give feedback. 

* Old files automatically get deleted by a cron job. Be sure to specify how long Fileship should hold on to old files. 

* Want to change Fileship's look? You can give Fileship a custom logo, and even load a custom stylesheet! See EXAMPLE_STYLESHEET.css for a list of css attributes that you can change. 



## Technical details
* Ruby 1.9.3
* Rails 3.2.13
* Uploaded files are stored in 'public' -> 'uploads'
* Works best on javascript enabled


## License:

(The MIT License)

Copyright (c) 2012 Central Web Services, Oregon State University

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.