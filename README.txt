Hi!

This is a simple modification of the wonderful HGEDITOR.SH script that is 
distributed with the Mercurial version control system. I've simply modified it
to understand how to use Git. 

To make it work, edit your .gitconfig and add in the following line:

[core]
    editor = /path/to/giteditor.sh

Or:

git config --global /path/to/giteditor.sh

If you discover any bugs, please do raise an issue so that I can fix.

Enjoy!

-=david=-
