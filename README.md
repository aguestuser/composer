# Crisis Box Composer

* composes isntallation and deployment of services for crisbox, currently:
  * [crisisbox-intake-form](https://github.com/aguestuser/crisisbox-intake-form)
  * [crisisbox-intake-receiver](https://github.com/aguestuser/crisisbox-intake-receiver)
* built for "thin slice" proof-of-concept for crisisbox (see [kanban board](https://apps.unite.tech/grain/XLesz7hbLomKAtL2AfzT53) for details)
* to be moved to self-hosted gitlab repo once configured

# To Run

* make sure nothing is running on either ports 3000 or 3001
* run the following in your favorite shell:

```
$ git clone git@github.com:aguestuser/crisisbox-composer
$ cd crisisbox-composer/bin
$ ./install.sh
$ ./run.sh
```

* point your favorite browser to `http://localhost:3000`
