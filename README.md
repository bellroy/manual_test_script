ManualTestScript
================

A manual test script runner you can run along with.


Example
=======

Run:
  rake test:manual

This will parse your manual test script in /spec/manual_testing.txt
The file takes the following format:

  - Section Heading
  --------------------------------------------------------------------------------
  You are able to log in.
  Another assertion.
  Concerning some specific part:
    You can do this.
    You can do that.
    You can do most things,
    Wearing a hat,
      Just not that...
  
  - Another section
  --------------------------------------------------------------------------------
  ...

Hooks
=====

To customise the script intro, set up an initializer like:

  ManualTestScript.intro = Proc.new do
    puts "Something special"
    Hyperdrive.prime!
    # ready to go...
  end

Copyright (c) 2009 Trike IT, released under the MIT license
