govCMS 4 Docker
===============

This Dockerfile can be used to spin up a govCMS test/evaluation instance.

Commands
--------

```
# Instantiate a new MySQL container to house your database.
docker run --name db -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=drupal -e MYSQL_USER=drupal -e MYSQL_PASSWORD=drupal -d mysql:5.6.25

# Create the govCMS container to pull in the codebase and run the webserver - linking it to the db container.
docker run -p 8888:80 --name govcms --link db:db govcms
```


Install
-------

Installation can either be done using Phing/Drush from the command line or through the GUI in a web browser.

### Command line (preferred)

```
#Connect to the container
docker exec -ti govcms /bin/bash

#Run the install task
phing -f build/phing/build.xml install
```

### Browser based

* Find the IP address of your container

```
# When using a mac.
boot2docker ip
```

* Access the install pages at \<ip address\>:8888
* Fill in database information:
  * DB Username: drupal
  * DB Password: drupal
  * DB Name: drupal
  * DB Host: db
* Run through the rest of the install procedure as usual.
