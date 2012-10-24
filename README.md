ExpertizaE619B-
===============

test cases for helper and controller of file review

The project was to write test cases for a couple of classes "expertiza/app/helpers/diff_helper.rb" and "expertiza/app/controllers/review_files_controller.rb"

The test files are "diff_helper_test.rb"(unit) and "review_files_controller_test.rb"(functional)

There was one bug in the "review_files_controller.rb" which we have now fixed.

Steps:

get the code from => git clone https://github.com/shoubhik/ExpertizaE619B-
1-install ruby 1.8.7 and rails 2.3.4
2-install mysql (in windows the dlls and in unix there will be a few dependencies, depending on the flavour). apparently there are many different alternatives. the best way is to just setup expertiza. if expertiza runs in dev mode then the tests should work out of the box. tests have no dpenedency on dev environment, it just means your system is ready.
4-in mysql create a db : pg_test (for some reason rails in unable to creat the db on my machine.
   4.1: In the database.yml file enter the root username and password for the mysql server
5-run rake RAILS_ENV=test db:migrate (from within the root dir.
6-run rake RAILS_ENV=test db:fixtures:load
7- run the test cases 
   a-ruby -Itest test/unit/helpers/diff_helper_test.rb
   b-a-ruby -Itest test/functional/review_files_controller_test.rb


